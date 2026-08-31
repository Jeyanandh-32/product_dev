import 'package:backend/database/schema.dart';
import 'package:backend/services/cache/in_memory_cache.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for managing merchant store records with native in-memory caching.
class StoreRepository {
  StoreRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;
  static final _slugCache = InMemoryCache<StoreRow?>();
  static final _idCache = InMemoryCache<StoreRow?>();

  /// Creates a new store and clears store cache.
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

    _clearCache();
    return row;
  }

  /// Retrieves paginated list of stores.
  Future<List<StoreRow>> getAll({
    required String merchantId,
    int? limit,
    int? offset,
  }) async {
    var query = _db.stores.where((s) => s.merchantId.equalsValue(merchantId));
    if (offset != null) query = query.offset(offset);
    if (limit != null) query = query.limit(limit);
    return query.fetch();
  }

  /// Retrieves list of stores enabled for online ordering.
  Future<List<StoreRow>> getOnlineStores({int? limit, int? offset}) async {
    var query = _db.stores.where(
      (s) => s.isActive.equalsValue(true) & s.isOnlineEnabled.equalsValue(true),
    );
    if (offset != null) query = query.offset(offset);
    if (limit != null) query = query.limit(limit);
    return query.fetch();
  }

  /// Counts total online-enabled stores.
  Future<int> countOnlineStores() async {
    final query = _db.stores.where(
      (s) => s.isActive.equalsValue(true) & s.isOnlineEnabled.equalsValue(true),
    );
    return (await query.count().fetch()) ?? 0;
  }

  /// Retrieves online store by [slug] with in-memory caching.
  Future<StoreRow?> getBySlug(String slug) async {
    final cached = _slugCache.get(slug);
    if (cached != null) return cached;

    final row = await _db.stores
        .where(
          (s) => s.slug.equalsValue(slug) & s.isActive.equalsValue(true),
        )
        .first
        .fetch();

    if (row != null) _slugCache.set(slug, row);
    return row;
  }

  /// Counts total stores for a merchant.
  Future<int> count({required String merchantId}) async {
    final query = _db.stores.where((s) => s.merchantId.equalsValue(merchantId));
    return (await query.count().fetch()) ?? 0;
  }

  /// Retrieves store by ID with in-memory caching.
  Future<StoreRow?> getById(String id) async {
    final cached = _idCache.get(id);
    if (cached != null) return cached;

    final row = await _db.stores.byKey(id).fetch();
    if (row != null) _idCache.set(id, row);
    return row;
  }

  /// Updates store and invalidates cache.
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
            storeType: updateStoreType
                ? ts.toExpr(storeType?.name)
                : s.storeType,
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

    _clearCache();
    return row;
  }

  static void _clearCache() {
    _slugCache.clear();
    _idCache.clear();
  }
}
