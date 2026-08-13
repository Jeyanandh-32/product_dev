import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class StoreRepository {
  StoreRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;

  Future<StoreRow> create({
    required String merchantId,
    required String name,
    StoreType? storeType,
    bool isOnlineEnabled = false,
    PaymentProvider activePaymentProvider = PaymentProvider.phonepe,
    String? slug,
  }) async {
    final row = await _db.stores
        .insertValue(
          merchantId: merchantId,
          name: name,
          storeType: storeType?.name,
          isOnlineEnabled: isOnlineEnabled,
          activePaymentProvider: activePaymentProvider.name,
          slug: slug,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<List<StoreRow>> getAll({
    required String merchantId,
    int? limit,
    int? offset,
  }) async {
    var query = _db.stores.where((s) => s.merchantId.equalsValue(merchantId));

    if (offset != null) {
      query = query.offset(offset);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final rows = await query.fetch();
    return rows;
  }

  Future<List<StoreRow>> getOnlineStores({
    int? limit,
    int? offset,
  }) async {
    var query = _db.stores.where(
      (s) => s.isActive.equalsValue(true) & s.isOnlineEnabled.equalsValue(true),
    );

    if (offset != null) {
      query = query.offset(offset);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final rows = await query.fetch();
    return rows;
  }

  Future<int> countOnlineStores() async {
    final query = _db.stores.where(
      (s) => s.isActive.equalsValue(true) & s.isOnlineEnabled.equalsValue(true),
    );
    final total = await query.count().fetch();
    return total ?? 0;
  }

  Future<StoreRow?> getBySlug(String slug) async {
    final row = await _db.stores
        .where(
          (s) =>
              s.slug.equalsValue(slug) &
              s.isActive.equalsValue(true) &
              s.isOnlineEnabled.equalsValue(true),
        )
        .first
        .fetch();
    return row;
  }

  Future<int> count({required String merchantId}) async {
    final query = _db.stores.where((s) => s.merchantId.equalsValue(merchantId));
    final total = await query.count().fetch();
    return total ?? 0;
  }

  Future<StoreRow?> getById(String id) async {
    final row = await _db.stores.byKey(id).fetch();
    return row;
  }

  Future<StoreRow?> update({
    required String id,
    String? name,
    StoreType? storeType,
    bool? isActive,
    bool? isOnlineEnabled,
    String? slug,
    bool updateStoreType = false,
    bool updateSlug = false,
  }) async {
    final row = await _db.stores
        .byKey(id)
        .update(
          (s, set) => set(
            name: name != null ? ts.toExpr(name) : s.name,
            storeType: updateStoreType ? ts.toExpr(storeType?.name) : s.storeType,
            isActive: isActive != null ? ts.toExpr(isActive) : s.isActive,
            isOnlineEnabled: isOnlineEnabled != null
                ? ts.toExpr(isOnlineEnabled)
                : s.isOnlineEnabled,
            slug: updateSlug ? ts.toExpr(slug) : s.slug,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }
}
