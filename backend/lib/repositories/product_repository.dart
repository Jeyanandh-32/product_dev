import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

class ProductRepository {
  ProductRepository({required this._db});

  final ts.Database<DatabaseSchema> _db;

  Future<ProductRow> create({
    required String merchantId,
    required String storeId,
    required String name,
    required String categoryId,
    required int basePrice,
    required int sellingPrice,
    String? counterId,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    final row = await _db.products
        .insertValue(
          merchantId: merchantId,
          storeId: storeId,
          name: name,
          categoryId: categoryId,
          counterId: counterId,
          basePrice: basePrice,
          sellingPrice: sellingPrice,
          taxRate: taxRate,
          sku: sku,
          barcode: barcode,
          description: description,
          imageUrl: imageUrl,
        )
        .returnInserted()
        .executeAndFetch();

    return row;
  }

  Future<ProductRow?> update({
    required String id,
    String? name,
    String? categoryId,
    String? counterId,
    bool? isActive,
    int? basePrice,
    int? sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    bool skuPresent = false,
    bool barcodePresent = false,
    bool descriptionPresent = false,
    bool imageUrlPresent = false,
  }) async {
    final row = await _db.products
        .byKey(id)
        .update(
          (p, set) => set(
            name: name != null ? ts.toExpr(name) : p.name,
            categoryId: categoryId != null
                ? ts.toExpr(categoryId)
                : p.categoryId,
            counterId: counterId != null ? ts.toExpr(counterId) : p.counterId,
            isActive: isActive != null ? ts.toExpr(isActive) : p.isActive,
            basePrice: basePrice != null ? ts.toExpr(basePrice) : p.basePrice,
            sellingPrice: sellingPrice != null
                ? ts.toExpr(sellingPrice)
                : p.sellingPrice,
            taxRate: taxRate != null ? ts.toExpr(taxRate) : p.taxRate,
            sku: skuPresent ? ts.toExpr(sku) : p.sku,
            barcode: barcodePresent ? ts.toExpr(barcode) : p.barcode,
            description: descriptionPresent
                ? ts.toExpr(description)
                : p.description,
            imageUrl: imageUrlPresent ? ts.toExpr(imageUrl) : p.imageUrl,
            updatedAt: ts.Expr.currentTimestamp,
          ),
        )
        .returnUpdated()
        .executeAndFetch();

    return row;
  }

  Future<List<(ProductRow, StockRow?, CategoryRow?, CounterRow?)>> getAll({
    String? merchantId,
    String? storeId,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final q = _db.products
        .leftJoin(_db.stocks)
        .on((p, s) => p.id.equals(s.productId))
        .leftJoin(_db.categories)
        .on((p, s, c) => p.categoryId.equals(c.id))
        .leftJoin(_db.counters)
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

  Future<(ProductRow, StockRow?, CategoryRow?, CounterRow?)?> getById(
    String id,
  ) async {
    final row = await _db.products
        .leftJoin(_db.stocks)
        .on((p, s) => p.id.equals(s.productId))
        .leftJoin(_db.categories)
        .on((p, s, c) => p.categoryId.equals(c.id))
        .leftJoin(_db.counters)
        .on((p, s, c, cnt) => p.counterId.equals(cnt.id))
        .where((p, s, c, cnt) => p.id.equalsValue(id))
        .first
        .fetch();

    return row;
  }

  Future<List<ProductRow>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    return _db.products.where((p) {
      var expr = p.id.equals(ts.toExpr(ids.first));
      for (var i = 1; i < ids.length; i++) {
        expr = expr.or(p.id.equals(ts.toExpr(ids[i])));
      }
      return expr;
    }).fetch();
  }

  Future<int> count({
    String? merchantId,
    String? storeId,
    String? searchQuery,
  }) async {
    final q = _db.products.where((p) {
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
