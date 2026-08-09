import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class CategoryRepository {
  CategoryRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;

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

    return row;
  }

  Future<List<CategoryRow>> getAll({
    required String merchantId,
    String? storeId,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    var query = _db.categories.where((c) {
      var expr = c.merchantId.equalsValue(merchantId);
      if (storeId != null) {
        expr = expr.and(c.storeId.equalsValue(storeId));
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final term = '%${searchQuery.trim().toLowerCase()}%';
        expr = expr.and(c.name.toLowerCase().like(term));
      }
      return expr;
    });

    if (offset != null) {
      query = query.offset(offset);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final rows = await query.fetch();
    return rows;
  }

  Future<int> count({
    required String merchantId,
    String? storeId,
    String? searchQuery,
  }) async {
    final query = _db.categories.where((c) {
      var expr = c.merchantId.equalsValue(merchantId);
      if (storeId != null) {
        expr = expr.and(c.storeId.equalsValue(storeId));
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final term = '%${searchQuery.trim().toLowerCase()}%';
        expr = expr.and(c.name.toLowerCase().like(term));
      }
      return expr;
    });

    final total = await query.count().fetch();
    return total ?? 0;
  }

  Future<CategoryRow?> getById(String id) async {
    final row = await _db.categories.byKey(id).fetch();
    return row;
  }

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
            description: descriptionPresent
                ? ts.toExpr(description)
                : c.description,
            imageUrl: imageUrlPresent ? ts.toExpr(imageUrl) : c.imageUrl,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }
}
