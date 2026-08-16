import 'package:backend/database/schema.dart';
import 'package:backend/repositories/product_query_builder.dart';
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
  }) =>
      ProductQueryBuilder.getAll(
        db: _db,
        merchantId: merchantId,
        storeId: storeId,
        searchQuery: searchQuery,
        limit: limit,
        offset: offset,
      );

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
  }) =>
      ProductQueryBuilder.count(
        db: _db,
        merchantId: merchantId,
        storeId: storeId,
        searchQuery: searchQuery,
      );
}
