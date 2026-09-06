import 'package:backend/database/schema.dart';
import 'package:backend/services/cache/in_memory_cache.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for handling terminal records with native in-memory caching.
class TerminalRepository {
  TerminalRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;
  static final _codeCache = InMemoryCache<TerminalRow?>();
  static final _listCache = InMemoryCache<List<TerminalRow>>();
  static final _countCache = InMemoryCache<int>();

  /// Creates a new terminal and clears terminal cache.
  Future<TerminalRow> create({
    required String code,
    required String merchantId,
    required String storeId,
    required String name,
    required String passwordHash,
  }) async {
    final row = await _db.terminals
        .insertValue(
          code: code,
          merchantId: merchantId,
          storeId: storeId,
          name: name,
          passwordHash: passwordHash,
        )
        .returnInserted()
        .executeAndFetch();

    _clearCache();
    return row;
  }

  /// Retrieves list of terminals with in-memory caching and deduplication.
  Future<List<TerminalRow>> getAll({
    required String merchantId,
    String? storeId,
    bool? isActive,
    int? limit,
    int? offset,
  }) {
    final key = '$merchantId:$storeId:$isActive:$limit:$offset';
    return _listCache.getOrFetch(key, () async {
      var query = _db.terminals.where(
        (t) => t.merchantId.equalsValue(merchantId),
      );
      if (storeId != null) {
        query = query.where((t) => t.storeId.equalsValue(storeId));
      }
      if (isActive != null) {
        query = query.where((t) => t.isActive.equalsValue(isActive));
      }
      if (offset != null) query = query.offset(offset);
      if (limit != null) query = query.limit(limit);
      return query.fetch();
    });
  }

  /// Counts matching terminals with in-memory caching.
  Future<int> count({
    required String merchantId,
    String? storeId,
    bool? isActive,
  }) {
    final key = '$merchantId:$storeId:$isActive';
    return _countCache.getOrFetch(key, () async {
      var query = _db.terminals.where(
        (t) => t.merchantId.equalsValue(merchantId),
      );
      if (storeId != null) {
        query = query.where((t) => t.storeId.equalsValue(storeId));
      }
      if (isActive != null) {
        query = query.where((t) => t.isActive.equalsValue(isActive));
      }
      final total = await query.count().fetch();
      return total ?? 0;
    });
  }

  /// Retrieves terminal by [code] with in-memory caching.
  Future<TerminalRow?> getByCode(String code) {
    return _codeCache.getOrFetch(code, () => _db.terminals.byKey(code).fetch());
  }

  /// Retrieves store row by [storeId].
  Future<StoreRow?> getStoreById(String storeId) {
    return _db.stores.byKey(storeId).fetch();
  }

  /// Retrieves merchant row by [merchantId].
  Future<MerchantRow?> getMerchantById(String merchantId) {
    return _db.merchants.byKey(merchantId).fetch();
  }

  /// Updates terminal and invalidates cache.
  Future<TerminalRow?> update({
    required String code,
    String? name,
    String? passwordHash,
    bool? isActive,
  }) async {
    final row = await _db.terminals
        .byKey(code)
        .update(
          (t, set) => set(
            name: name != null ? ts.toExpr(name) : t.name,
            passwordHash: passwordHash != null
                ? ts.toExpr(passwordHash)
                : t.passwordHash,
            isActive: isActive != null ? ts.toExpr(isActive) : t.isActive,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    _clearCache();
    return row;
  }

  static void _clearCache() {
    _codeCache.clear();
    _listCache.clear();
    _countCache.clear();
  }
}
