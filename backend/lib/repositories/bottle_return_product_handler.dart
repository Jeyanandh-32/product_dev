import 'package:backend/database/schema.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Product returnable status item.
class ReturnableProductItem {
  const ReturnableProductItem({
    required this.productId,
    required this.name,
    required this.sellingPrice,
    required this.isReturnable,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.sku,
  });

  final String productId;
  final String name;
  final double sellingPrice;
  final bool isReturnable;
  final String? imageUrl;
  final String? categoryId;
  final String? categoryName;
  final String? sku;

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'sellingPrice': sellingPrice,
    'isReturnable': isReturnable,
    'imageUrl': imageUrl,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'sku': sku,
  };
}

/// Handler for configuring returnable bottle products for a store.
class BottleReturnProductHandler {
  const BottleReturnProductHandler({required this.db});

  final ts.Database<DatabaseSchema> db;

  /// Lists all products for a store with their returnable bottle status.
  Future<List<ReturnableProductItem>> getProductsForStore(
    String storeId,
  ) async {
    final products = await db.products
        .where(
          (p) =>
              p.storeId.equals(ts.toExpr(storeId)) &
              p.isActive.equals(ts.toExpr(true)),
        )
        .fetch();

    final returnableRows = await db.bottleReturnProducts
        .where(
          (r) =>
              r.storeId.equals(ts.toExpr(storeId)) &
              r.isReturnable.equals(ts.toExpr(true)),
        )
        .fetch();
    final returnableSet = returnableRows.map((r) => r.productId).toSet();

    final categoryIds = products.map((p) => p.categoryId).toSet().toList();
    final categories = await db.categories.where((c) {
      if (categoryIds.isEmpty) return ts.toExpr(false);
      var expr = c.id.equals(ts.toExpr(categoryIds.first));
      for (var i = 1; i < categoryIds.length; i++) {
        expr = expr.or(c.id.equals(ts.toExpr(categoryIds[i])));
      }
      return expr;
    }).fetch();
    final categoryMap = {for (final c in categories) c.id: c.name};

    return products.map((p) {
      return ReturnableProductItem(
        productId: p.id,
        name: p.name,
        sellingPrice: p.sellingPrice / 100.0,
        isReturnable: returnableSet.contains(p.id),
        imageUrl: p.imageUrl,
        categoryId: p.categoryId,
        categoryName: categoryMap[p.categoryId],
        sku: p.sku,
      );
    }).toList();
  }

  /// Toggles returnable status for a specific product.
  Future<void> setProductReturnable({
    required String storeId,
    required String productId,
    required bool isReturnable,
  }) async {
    final existing = await db.bottleReturnProducts
        .where((r) => r.productId.equals(ts.toExpr(productId)))
        .fetch();

    if (existing.isNotEmpty) {
      await db.bottleReturnProducts
          .where((r) => r.productId.equals(ts.toExpr(productId)))
          .update((r, set) => set(isReturnable: ts.toExpr(isReturnable)))
          .execute();
    } else if (isReturnable) {
      await db.bottleReturnProducts
          .insertValue(
            productId: productId,
            storeId: storeId,
            isReturnable: true,
          )
          .execute();
    }
  }

  /// Bulk updates returnable status for multiple products in a store.
  Future<void> bulkSetProductsReturnable({
    required String storeId,
    required List<String> productIds,
    required bool isReturnable,
  }) async {
    for (final id in productIds) {
      await setProductReturnable(
        storeId: storeId,
        productId: id,
        isReturnable: isReturnable,
      );
    }
  }
}
