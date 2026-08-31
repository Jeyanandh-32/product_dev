import 'package:backend/database/schema.dart';
import 'package:backend/repositories/subscription_lifecycle.dart';
import 'package:backend/repositories/subscription_renewal_executor.dart';
import 'package:backend/repositories/subscription_storage_helper.dart';
import 'package:backend/repositories/subscription_transaction_repository.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for managing subscription plans, store subscriptions, and renewals.
class SubscriptionRepository {
  SubscriptionRepository({required this.db})
      : _transactionRepo = SubscriptionTransactionRepository(db: db);

  final ts.Database<DatabaseSchema> db;
  final SubscriptionTransactionRepository _transactionRepo;

  /// Fetches all active subscription plans.
  Future<List<SubscriptionPlanRow>> getPlans() => db.subscriptionPlans.fetch();

  /// Fetches the subscription plan by [planCode].
  Future<SubscriptionPlanRow?> getPlanByCode(
    SubscriptionPlanCode planCode,
  ) async {
    final list = await db.subscriptionPlans
        .where((p) => p.code.equalsValue(planCode.name))
        .fetch();
    return list.firstOrNull;
  }

  /// Fetches current subscription for a store and computes live lifecycle status.
  Future<StoreSubscriptionRow?> getStoreSubscription(String storeId) async {
    final list = await db.storeSubscriptions
        .where((s) => s.storeId.equalsValue(storeId))
        .fetch();
    final sub = list.firstOrNull;
    if (sub == null) return null;

    final currentStatus = SubscriptionStatus.values
            .where(
              (s) =>
                  s.name == sub.status ||
                  s.name == sub.status.replaceAll('_', ''),
            )
            .firstOrNull ??
        SubscriptionStatus.active;

    final evaluatedStatus = SubscriptionLifecycle.evaluateStatus(
      endsAt: sub.endsAt,
      currentStatus: currentStatus,
      now: DateTime.now(),
      graceEndsAt: sub.graceEndsAt,
    );

    if (evaluatedStatus != currentStatus) {
      return SubscriptionStorageHelper.updateStatus(
        db: db,
        id: sub.id,
        status: evaluatedStatus,
      );
    }
    return sub;
  }

  /// Checks whether the store subscription is operational (trial, active, or in grace period).
  Future<bool> isStoreOperational(String storeId) async {
    final sub = await getStoreSubscription(storeId);
    if (sub == null) return false;

    final currentStatus = SubscriptionStatus.values
            .where(
              (s) =>
                  s.name == sub.status ||
                  s.name == sub.status.replaceAll('_', ''),
            )
            .firstOrNull ??
        SubscriptionStatus.expired;

    return currentStatus.isOperational;
  }

  /// Provisions a 14-day free trial for a newly created store.
  Future<StoreSubscriptionRow> provisionTrial(String storeId) async {
    final existing = await db.storeSubscriptions
        .where((s) => s.storeId.equalsValue(storeId))
        .fetch();
    if (existing.isNotEmpty) return existing.first;

    final (endsAt, graceEndsAt) = SubscriptionLifecycle.computeRenewalDates(
      planDurationDays: SubscriptionLifecycle.trialDurationDays,
      now: DateTime.now(),
    );

    return SubscriptionStorageHelper.insert(
      db: db,
      storeId: storeId,
      planCode: SubscriptionPlanCode.trial.name,
      status: SubscriptionStatus.trial.name,
      endsAt: endsAt,
      graceEndsAt: graceEndsAt,
    );
  }

  /// Records a pending subscription transaction before payment gateway redirect.
  Future<SubscriptionTransactionRow> recordPendingTransaction({
    required String storeId,
    required SubscriptionPlanCode planCode,
    required int amountInPaise,
    required String currency,
    required String reference,
    SubscriptionPaymentMethod paymentMethod =
        SubscriptionPaymentMethod.phonepe,
  }) => _transactionRepo.recordPending(
    storeId: storeId,
    planCode: planCode,
    amountInPaise: amountInPaise,
    currency: currency,
    reference: reference,
    paymentMethod: paymentMethod,
  );

  /// Renews or upgrades the store subscription with a chosen plan.
  Future<StoreSubscriptionRow> renewSubscription({
    required String storeId,
    required SubscriptionPlanCode planCode,
    SubscriptionPaymentMethod paymentMethod =
        SubscriptionPaymentMethod.simulated,
    String? reference,
  }) async {
    final plan = await getPlanByCode(planCode);
    final currentSub = await getStoreSubscription(storeId);
    return SubscriptionRenewalExecutor.execute(
      db: db,
      transactionRepo: _transactionRepo,
      storeId: storeId,
      plan: plan,
      currentSub: currentSub,
      planCode: planCode,
      paymentMethod: paymentMethod,
      reference: reference,
    );
  }

  /// Fetches completed transaction history for a store.
  Future<List<SubscriptionTransactionRow>> getTransactions(
    String storeId, {
    bool completedOnly = true,
  }) => _transactionRepo.getTransactions(storeId, completedOnly: completedOnly);
}
