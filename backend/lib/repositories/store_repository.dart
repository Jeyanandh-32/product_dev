import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class StoreRepository {
  StoreRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

  final ts.Database<DatabaseSchema> _db;

  Future<StoreRow> create({
    required String merchantId,
    required String name,
    String? storeType,
  }) async {
    final row = await _db.stores
        .insertValue(
          merchantId: merchantId,
          name: name,
          storeType: storeType,
        )
        .returning((ts.Expr<StoreRow> s) => (s,))
        .executeAndFetch();

    return row;
  }

  Future<List<StoreRow>> getAll({required String merchantId}) async {
    final rows = await _db.stores
        .where((s) => s.merchantId.equalsValue(merchantId))
        .fetch();

    return rows;
  }

  Future<StoreRow?> getById(String id) async {
    final row = await _db.stores.byKey(id).fetch();
    return row;
  }

  Future<StoreRow?> update({
    required String id,
    String? name,
    String? storeType,
    bool? isActive,
    bool updateStoreType = false,
  }) async {
    final row = await _db.stores
        .byKey(id)
        .update(
          (s, set) => set(
            name: name != null ? ts.toExpr(name) : s.name,
            storeType: updateStoreType ? ts.toExpr(storeType) : s.storeType,
            isActive: isActive != null ? ts.toExpr(isActive) : s.isActive,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returning((ts.Expr<StoreRow> s) => (s,))
        .executeAndFetch();

    return row;
  }
}
