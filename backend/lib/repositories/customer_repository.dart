import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class CustomerRepository {
  CustomerRepository({required this.db});

  final ts.Database<DatabaseSchema> db;

  Future<CustomerRow> create({
    required String name,
    required String mobileNumber,
    required String pinHash,
  }) async {
    final row = await db.customers
        .insertValue(
          name: name,
          mobileNumber: mobileNumber,
          pinHash: pinHash,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<CustomerRow?> getByMobileNumber(String mobileNumber) async {
    final row = await db.customers
        .where((c) => c.mobileNumber.equalsValue(mobileNumber))
        .first
        .fetch();
    return row;
  }

  Future<CustomerRow?> getById(String id) async {
    final row = await db.customers.byKey(id).fetch();
    return row;
  }

  Future<void> recordStoreVisit({
    required String customerId,
    required String storeId,
  }) async {
    final existing = await db.customerRecentStores
        .byKey(customerId, storeId)
        .fetch();

    if (existing != null) {
      await db.customerRecentStores
          .byKey(customerId, storeId)
          .update(
            (r, set) => set(
              lastVisitedAt: ts.Expr.currentTimestamp,
            ),
          )
          .execute();
    } else {
      await db.customerRecentStores
          .insertValue(
            customerId: customerId,
            storeId: storeId,
          )
          .execute();
    }
  }

  Future<List<StoreRow>> getRecentStores({
    required String customerId,
    int limit = 5,
  }) async {
    final recentRows = await db.customerRecentStores
        .where((r) => r.customerId.equalsValue(customerId))
        .orderBy((r) => [(r.lastVisitedAt, ts.Order.descending)])
        .limit(limit)
        .fetch();

    if (recentRows.isEmpty) return [];

    final allStores = await db.stores
        .where(
          (s) =>
              s.isActive.equalsValue(true) &
              s.isOnlineEnabled.equalsValue(true),
        )
        .fetch();

    final storeIds = recentRows.map((r) => r.storeId).toSet();
    final matchingStores = allStores
        .where((s) => storeIds.contains(s.id))
        .toList();

    final storeMap = {for (final s in matchingStores) s.id: s};
    final ordered = <StoreRow>[];
    for (final r in recentRows) {
      final s = storeMap[r.storeId];
      if (s != null) ordered.add(s);
    }

    return ordered;
  }

  Future<CustomerRow?> update({
    required String id,
    String? name,
    String? mobileNumber,
    String? pinHash,
  }) async {
    final row = await db.customers
        .byKey(id)
        .update(
          (c, set) => set(
            name: name != null ? ts.toExpr(name) : c.name,
            mobileNumber:
                mobileNumber != null ? ts.toExpr(mobileNumber) : c.mobileNumber,
            pinHash: pinHash != null ? ts.toExpr(pinHash) : c.pinHash,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }

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
