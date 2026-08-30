import 'package:backend/database/schema.dart';
import 'package:backend/exceptions/subscription_exceptions.dart';
import 'package:backend/repositories/subscription_lifecycle.dart';
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
  Future<SubscriptionPlanRow?> getPlanByCode(SubscriptionPlanCode planCode) async {
    final list = await db.subscriptionPlans.where((p) => p.code.equalsValue(planCode.name)).fetch();
    return list.firstOrNull;
  }

  /// Fetches current subscription for a store and computes live lifecycle status.
  Future<StoreSubscriptionRow?> getStoreSubscription(String storeId) async {
    final list = await db.storeSubscriptions.where((s) => s.storeId.equalsValue(storeId)).fetch();
    final sub = list.firstOrNull;
    if (sub == null) return null;

    final currentStatus = SubscriptionStatus.values
            .where((s) => s.name == sub.status || s.name == sub.status.replaceAll('_', ''))
            .firstOrNull ??
        SubscriptionStatus.active;

    final evaluatedStatus = SubscriptionLifecycle.evaluateStatus(
      endsAt: sub.endsAt,
      currentStatus: currentStatus,
      now: DateTime.now(),
      graceEndsAt: sub.graceEndsAt,
    );

    if (evaluatedStatus != currentStatus) {
      return SubscriptionStorageHelper.updateStatus(db: db, id: sub.id, status: evaluatedStatus);
    }
    return sub;
  }

  /// Provisions a 14-day free trial for a newly created store.
  Future<StoreSubscriptionRow> provisionTrial(String storeId) async {
    final existing = await db.storeSubscriptions.where((s) => s.storeId.equalsValue(storeId)).fetch();
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
    SubscriptionPaymentMethod paymentMethod = SubscriptionPaymentMethod.phonepe,
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
    SubscriptionPaymentMethod paymentMethod = SubscriptionPaymentMethod.simulated,
    String? reference,
  }) async {
    final plan = await getPlanByCode(planCode);
    if (plan == null) throw SubscriptionPlanNotFoundException(planCode.name);

    final currentSub = await getStoreSubscription(storeId);
    final now = DateTime.now();
    final (endsAt, graceEndsAt) = SubscriptionLifecycle.computeRenewalDates(
      existingEndsAt: currentSub?.endsAt,
      planDurationDays: plan.durationDays,
      now: now,
    );

    if (reference != null) {
      await _transactionRepo.recordCompleted(
        storeId: storeId,
        planCode: planCode,
        amountInPaise: plan.priceInPaise,
        currency: plan.currency,
        paymentMethod: paymentMethod,
        reference: reference,
      );
    }

    if (currentSub == null) {
      return SubscriptionStorageHelper.insert(
        db: db,
        storeId: storeId,
        planCode: planCode.name,
        status: SubscriptionStatus.active.name,
        endsAt: endsAt,
        graceEndsAt: graceEndsAt,
      );
    }

    return (await db.storeSubscriptions.byKey(currentSub.id).update((s, set) => set(
              planCode: ts.toExpr(planCode.name),
              status: ts.toExpr(SubscriptionStatus.active.name),
              endsAt: ts.toExpr(endsAt),
              graceEndsAt: ts.toExpr(graceEndsAt),
              updatedAt: ts.Expr.currentTimestamp,
            )).returnUpdated().executeAndFetch()) ??
        (await getStoreSubscription(storeId)) ??
        (throw SubscriptionNotFoundException(storeId));
  }

  /// Fetches completed transaction history for a store.
  Future<List<SubscriptionTransactionRow>> getTransactions(
    String storeId, {
    bool completedOnly = true,
  }) => _transactionRepo.getTransactions(storeId, completedOnly: completedOnly);
}
