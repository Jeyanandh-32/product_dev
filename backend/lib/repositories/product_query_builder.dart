import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Query builder helper for products catalog listing and counts.
class ProductQueryBuilder {
  const ProductQueryBuilder._();

  /// Fetches paginated products with joined stock, category, and counter records.
  static Future<List<(ProductRow, StockRow?, CategoryRow?, CounterRow?)>> getAll({
    required ts.Database<DatabaseSchema> db,
    String? merchantId,
    String? storeId,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final q = db.products
        .leftJoin(db.stocks)
        .on((p, s) => p.id.equals(s.productId))
        .leftJoin(db.categories)
        .on((p, s, c) => p.categoryId.equals(c.id))
        .leftJoin(db.counters)
        .on((p, s, c, cnt) => p.counterId.equals(cnt.id))
        .where((p, s, c, cnt) {
          ts.Expr<bool?>? expr;
          if (merchantId != null) {
            expr = p.merchantId.equalsValue(merchantId);
          }
          if (storeId != null) {
            final storeExpr = p.storeId.equalsValue(storeId);
            expr = expr == null ? storeExpr : expr.and(storeExpr);
          }
          if (searchQuery != null && searchQuery.trim().isNotEmpty) {
            final term = '%${searchQuery.trim().toLowerCase()}%';
            final searchExpr = p.name.toLowerCase().like(term);
            expr = expr == null ? searchExpr : expr.and(searchExpr);
          }

          return expr ?? ts.toExpr(true);
        });

    var finalQuery = q
        .orderBy(
          (p, s, c, cnt) => [
            (p.createdAt, ts.Order.descending),
          ],
        )
        .asQuery;

    if (offset != null) {
      finalQuery = finalQuery.offset(offset);
    }
    if (limit != null) {
      finalQuery = finalQuery.limit(limit);
    }

    final rows = await finalQuery.fetch();
    return rows;
  }

  /// Counts total products matching search query and filters.
  static Future<int> count({
    required ts.Database<DatabaseSchema> db,
    String? merchantId,
    String? storeId,
    String? searchQuery,
  }) async {
    final q = db.products.where((p) {
      ts.Expr<bool?>? expr;
      if (merchantId != null) {
        expr = p.merchantId.equalsValue(merchantId);
      }
      if (storeId != null) {
        final storeExpr = p.storeId.equalsValue(storeId);
        expr = expr == null ? storeExpr : expr.and(storeExpr);
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final term = '%${searchQuery.trim().toLowerCase()}%';
        final searchExpr = p.name.toLowerCase().like(term);
        expr = expr == null ? searchExpr : expr.and(searchExpr);
      }

      return expr ?? ts.toExpr(true);
    });

    final count = await q.count().fetch();
    return count ?? 0;
  }
}
