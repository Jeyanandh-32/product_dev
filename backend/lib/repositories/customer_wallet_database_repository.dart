import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for customer store-specific wallets and transaction records.
class CustomerWalletDatabaseRepository {
  const CustomerWalletDatabaseRepository({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Updates or initializes the customer wallet balance for a specific store.
  Future<CustomerStoreWalletRow?> updateStoreWalletBalance({
    required String customerId,
    required String storeId,
    required int amountDeltaPaise,
  }) async {
    final existing = await db.customerStoreWallets
        .where(
          (w) =>
              w.customerId.equalsValue(customerId) &
              w.storeId.equalsValue(storeId),
        )
        .first
        .fetch();

    final currentBalance = existing?.walletBalance ?? 0;
    final newBalance = currentBalance + amountDeltaPaise;
    if (newBalance < 0) return null;

    if (existing == null) {
      return db.customerStoreWallets
          .insertValue(
            customerId: customerId,
            storeId: storeId,
            walletBalance: newBalance,
          )
          .returnInserted()
          .executeAndFetch();
    } else {
      final updatedList = await db.customerStoreWallets
          .where(
            (w) =>
                w.customerId.equalsValue(customerId) &
                w.storeId.equalsValue(storeId),
          )
          .update(
            (w, set) => set(
              walletBalance: ts.toExpr(newBalance),
              updatedAt: ts.Expr.currentTimestamp,
            ),
          )
          .returnUpdated()
          .executeAndFetch();
      return updatedList.isNotEmpty ? updatedList.first : null;
    }
  }

  /// Fetches the store wallet balance in paise for a customer.
  Future<int> getStoreWalletBalance({
    required String customerId,
    required String storeId,
  }) async {
    final row = await db.customerStoreWallets
        .where(
          (w) =>
              w.customerId.equalsValue(customerId) &
              w.storeId.equalsValue(storeId),
        )
        .first
        .fetch();
    return row?.walletBalance ?? 0;
  }

  /// Inserts a new customer wallet transaction log entry.
  Future<CustomerWalletTransactionRow> createWalletTransaction({
    required String customerId,
    required String storeId,
    required int amount,
    required String type,
    String? reference,
    String status = 'completed',
  }) async {
    return db.customerWalletTransactions
        .insertValue(
          customerId: customerId,
          storeId: storeId,
          amount: amount,
          type: type,
          reference: reference,
          status: status,
        )
        .returnInserted()
        .executeAndFetch();
  }

  /// Updates status for an asynchronous wallet transaction.
  Future<CustomerWalletTransactionRow?> updateWalletTransactionStatus({
    required String id,
    required String status,
  }) async {
    return db.customerWalletTransactions
        .byKey(id)
        .update(
          (t, set) => set(
            status: ts.toExpr(status),
          ),
        )
        .returnUpdated()
        .executeAndFetch();
  }

  /// Fetches all transaction records for a customer within a store.
  Future<List<CustomerWalletTransactionRow>> getWalletTransactions({
    required String customerId,
    required String storeId,
  }) async {
    return db.customerWalletTransactions
        .where(
          (t) =>
              t.customerId.equalsValue(customerId) &
              t.storeId.equalsValue(storeId),
        )
        .fetch();
  }
}
