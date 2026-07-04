import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class CategoryRepository {
  CategoryRepository({required ts.Database<DatabaseSchema> db}) : _db = db;

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
        .returning((ts.Expr<CategoryRow> c) => (c,))
        .executeAndFetch();

    return row;
  }

  Future<List<CategoryRow>> getAll({
    required String merchantId,
    String? storeId,
  }) async {
    final query = _db.categories.where(
      (c) => c.merchantId.equalsValue(merchantId),
    );

    if (storeId != null) {
      final rows = await query
          .where((c) => c.storeId.equalsValue(storeId))
          .fetch();
      return rows;
    }

    final rows = await query.fetch();
    return rows;
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
        .returning((ts.Expr<CategoryRow> c) => (c,))
        .executeAndFetch();

    return row;
  }
}
