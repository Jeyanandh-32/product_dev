import 'package:backend/database/schema.dart';
import 'package:backend/services/cache/in_memory_cache.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Repository for handling category records with native in-memory caching.
class CategoryRepository {
  CategoryRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;
  static final _listCache = InMemoryCache<List<CategoryRow>>();
  static final _countCache = InMemoryCache<int>();
  static final _idCache = InMemoryCache<CategoryRow?>();

  /// Creates a new category and invalidates category cache.
  Future<CategoryRow> create({
    required String name,
    required String merchantId,
    required String storeId,
    String? description,
    String? imageUrl,
  }) async {
    final row = await _db.categories
        .insertValue(
          name: name,
          merchantId: merchantId,
          storeId: storeId,
          description: description,
          imageUrl: imageUrl,
        )
        .returnInserted()
        .executeAndFetch();

    _clearCache();
    return row;
  }

  /// Retrieves list of categories with in-memory caching and deduplication.
  Future<List<CategoryRow>> getAll({
    String? merchantId,
    String? storeId,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    final key = '$merchantId:$storeId:$searchQuery:$limit:$offset';
    return _listCache.getOrFetch(key, () async {
      var query = _db.categories.where((c) {
        ts.Expr<bool?>? expr;
        if (merchantId != null) expr = c.merchantId.equalsValue(merchantId);
        if (storeId != null) {
          final storeExpr = c.storeId.equalsValue(storeId);
          expr = expr == null ? storeExpr : expr.and(storeExpr);
        }
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final term = '%${searchQuery.trim().toLowerCase()}%';
          final searchExpr = c.name.toLowerCase().like(term);
          expr = expr == null ? searchExpr : expr.and(searchExpr);
        }
        return expr ?? ts.toExpr(true);
      });

      if (offset != null) query = query.offset(offset);
      if (limit != null) query = query.limit(limit);

      return query.fetch();
    });
  }

  /// Counts matching categories with in-memory caching and deduplication.
  Future<int> count({
    String? merchantId,
    String? storeId,
    String? searchQuery,
  }) {
    final key = '$merchantId:$storeId:$searchQuery';
    return _countCache.getOrFetch(key, () async {
      final query = _db.categories.where((c) {
        ts.Expr<bool?>? expr;
        if (merchantId != null) expr = c.merchantId.equalsValue(merchantId);
        if (storeId != null) {
          final storeExpr = c.storeId.equalsValue(storeId);
          expr = expr == null ? storeExpr : expr.and(storeExpr);
        }
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final term = '%${searchQuery.trim().toLowerCase()}%';
          final searchExpr = c.name.toLowerCase().like(term);
          expr = expr == null ? searchExpr : expr.and(searchExpr);
        }
        return expr ?? ts.toExpr(true);
      });

      final total = await query.count().fetch();
      return total ?? 0;
    });
  }

  /// Retrieves category by ID with in-memory caching.
  Future<CategoryRow?> getById(String id) {
    return _idCache.getOrFetch(id, () => _db.categories.byKey(id).fetch());
  }

  /// Updates category and invalidates cache.
  Future<CategoryRow?> update({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    bool descriptionPresent = false,
    String? imageUrl,
    bool imageUrlPresent = false,
  }) async {
    final row = await _db.categories
        .byKey(id)
        .update(
          (c, set) => set(
            name: name != null ? ts.toExpr(name) : c.name,
            isActive: isActive != null ? ts.toExpr(isActive) : c.isActive,
            description: descriptionPresent ? ts.toExpr(description) : c.description,
            imageUrl: imageUrlPresent ? ts.toExpr(imageUrl) : c.imageUrl,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    _clearCache();
    return row;
  }

  static void _clearCache() {
    _listCache.clear();
    _countCache.clear();
    _idCache.clear();
  }
}
