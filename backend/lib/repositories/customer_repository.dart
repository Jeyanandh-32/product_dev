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
}
