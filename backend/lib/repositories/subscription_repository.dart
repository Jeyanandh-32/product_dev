import 'package:backend/database/schema.dart';
import 'package:backend/exceptions/subscription_exceptions.dart';
import 'package:backend/repositories/subscription_lifecycle.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for managing subscription plans, store subscriptions, and renewals.
class SubscriptionRepository {
  /// Creates a [SubscriptionRepository] with database handle [db].
  SubscriptionRepository({required this.db});

  /// The active database instance.
  final ts.Database<DatabaseSchema> db;

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

    final currentStatus = SubscriptionStatus.values.where(
      (s) => s.name == sub.status || s.name == sub.status.replaceAll('_', ''),
    ).firstOrNull ?? SubscriptionStatus.active;

    final evaluatedStatus = SubscriptionLifecycle.evaluateStatus(
      endsAt: sub.endsAt,
      currentStatus: currentStatus,
      now: DateTime.now(),
      graceEndsAt: sub.graceEndsAt,
    );

    if (evaluatedStatus != currentStatus) {
      return _updateStatus(sub.id, evaluatedStatus);
    }
    return sub;
  }

  /// Provisions a 14-day free trial for a newly created store.
  Future<StoreSubscriptionRow> provisionTrial(String storeId) async {
    final existing = await db.storeSubscriptions.where((s) => s.storeId.equalsValue(storeId)).fetch();
    if (existing.isNotEmpty) return existing.first;

    final now = DateTime.now();
    final (endsAt, graceEndsAt) = SubscriptionLifecycle.computeRenewalDates(
      planDurationDays: SubscriptionLifecycle.trialDurationDays,
      now: now,
    );

    return db.storeSubscriptions.insertValue(
      storeId: storeId,
      planCode: SubscriptionPlanCode.trial.name,
      status: SubscriptionStatus.trial.name,
      startsAt: now,
      endsAt: endsAt,
      graceEndsAt: graceEndsAt,
      autoRenew: true,
    ).returnInserted().executeAndFetch();
  }

  /// Renews or upgrades the store subscription with a chosen plan.
  Future<StoreSubscriptionRow> renewSubscription({
    required String storeId,
    required SubscriptionPlanCode planCode,
    SubscriptionPaymentMethod paymentMethod = SubscriptionPaymentMethod.simulated,
    String? reference,
  }) async {
    final plan = await getPlanByCode(planCode);
    if (plan == null) {
      throw SubscriptionPlanNotFoundException(planCode.name);
    }

    final currentSub = await getStoreSubscription(storeId);
    final now = DateTime.now();
    final (endsAt, graceEndsAt) = SubscriptionLifecycle.computeRenewalDates(
      existingEndsAt: currentSub?.endsAt,
      planDurationDays: plan.durationDays,
      now: now,
    );

    await db.subscriptionTransactions.insertValue(
      storeId: storeId,
      planCode: planCode.name,
      amountInPaise: plan.priceInPaise,
      currency: plan.currency,
      paymentMethod: paymentMethod.name,
      reference: reference ?? 'SIM-${DateTime.now().millisecondsSinceEpoch}',
      status: PaymentStatus.completed.name,
    ).execute();

    if (currentSub == null) {
      return db.storeSubscriptions.insertValue(
        storeId: storeId,
        planCode: planCode.name,
        status: SubscriptionStatus.active.name,
        startsAt: now,
        endsAt: endsAt,
        graceEndsAt: graceEndsAt,
        autoRenew: true,
      ).returnInserted().executeAndFetch();
    }

    return (await db.storeSubscriptions.byKey(currentSub.id).update(
      (s, set) => set(
        planCode: ts.toExpr(planCode.name),
        status: ts.toExpr(SubscriptionStatus.active.name),
        endsAt: ts.toExpr(endsAt),
        graceEndsAt: ts.toExpr(graceEndsAt),
        updatedAt: ts.Expr.currentTimestamp,
      ),
    ).returnUpdated().executeAndFetch()) ?? (await getStoreSubscription(storeId)) ?? (throw SubscriptionNotFoundException(storeId));
  }

  /// Fetches transaction history for a store.
  Future<List<SubscriptionTransactionRow>> getTransactions(String storeId) {
    return db.subscriptionTransactions
        .where((t) => t.storeId.equalsValue(storeId))
        .orderBy((t) => [(t.createdAt, ts.Order.descending)])
        .fetch();
  }

  Future<StoreSubscriptionRow?> _updateStatus(String id, SubscriptionStatus status) {
    return db.storeSubscriptions
        .byKey(id)
        .update((s, set) => set(
              status: ts.toExpr(status.name),
              updatedAt: ts.Expr.currentTimestamp,
            ))
        .returnUpdated()
        .executeAndFetch();
  }
}
