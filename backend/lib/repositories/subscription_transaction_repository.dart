import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for managing store subscription transaction logs and history.
class SubscriptionTransactionRepository {
  /// Creates a transaction repository instance with [db].
  const SubscriptionTransactionRepository({required this.db});

  /// Database connection instance.
  final ts.Database<DatabaseSchema> db;

  /// Records a pending subscription transaction before payment gateway redirect.
  Future<SubscriptionTransactionRow> recordPending({
    required String storeId,
    required SubscriptionPlanCode planCode,
    required int amountInPaise,
    required String currency,
    required String reference,
    SubscriptionPaymentMethod paymentMethod = SubscriptionPaymentMethod.phonepe,
  }) {
    return db.subscriptionTransactions
        .insertValue(
          storeId: storeId,
          planCode: planCode.name,
          amountInPaise: amountInPaise,
          currency: currency,
          paymentMethod: paymentMethod.name,
          reference: reference,
          status: 'pending',
        )
        .returnInserted()
        .executeAndFetch();
  }

  /// Records or marks a completed subscription transaction.
  Future<void> recordCompleted({
    required String storeId,
    required SubscriptionPlanCode planCode,
    required int amountInPaise,
    required String currency,
    required SubscriptionPaymentMethod paymentMethod,
    required String reference,
  }) async {
    final existingTx =
        (await db.subscriptionTransactions
                .where((t) => t.reference.equalsValue(reference))
                .fetch())
            .firstOrNull;

    if (existingTx != null) {
      await db.subscriptionTransactions
          .byKey(existingTx.id)
          .update((t, set) => set(status: ts.toExpr('completed')))
          .execute();
    } else {
      await db.subscriptionTransactions
          .insertValue(
            storeId: storeId,
            planCode: planCode.name,
            amountInPaise: amountInPaise,
            currency: currency,
            paymentMethod: paymentMethod.name,
            reference: reference,
            status: 'completed',
          )
          .execute();
    }
  }

  /// Fetches transaction history for [storeId].
  Future<List<SubscriptionTransactionRow>> getTransactions(
    String storeId, {
    bool completedOnly = true,
  }) {
    if (completedOnly) {
      return db.subscriptionTransactions
          .where(
            (t) =>
                t.storeId.equalsValue(storeId) &
                (t.status.equalsValue('completed') |
                    t.status.equalsValue('success')),
          )
          .orderBy((t) => [(t.createdAt, ts.Order.descending)])
          .fetch();
    }
    return db.subscriptionTransactions
        .where((t) => t.storeId.equalsValue(storeId))
        .orderBy((t) => [(t.createdAt, ts.Order.descending)])
        .fetch();
  }
}
