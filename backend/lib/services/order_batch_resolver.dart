import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';

/// A validated line item with pricing, tax rate, and discount.
typedef ResolvedOrderItem = ({
  String productId,
  int quantity,
  int sellingPrice,
  double taxRate,
  double discount,
});

/// Validates product existence, active status, category status, and stock availability.
class OrderBatchResolver {
  const OrderBatchResolver._();

  /// Resolves line items for order calculation, verifying active status and stock.
  static Future<List<ResolvedOrderItem>> resolve({
    required ProductRepository productRepo,
    required StockRepository stockRepo,
    required String storeId,
    required List<Map<String, dynamic>> productsInput,
  }) async {
    final resolvedItems = <ResolvedOrderItem>[];

    for (final p in productsInput) {
      final productId = p['productId'] as String;
      final quantity = p['quantity'] as int;
      final discount = (p['discount'] as num?)?.toDouble() ?? 0.0;

      final result = await productRepo.getById(productId);
      if (result == null) {
        throw Exception('Product with id "$productId" not found');
      }

      final (productRow, _, categoryRow, _) = result;
      if (!productRow.isActive) {
        throw Exception(
          'Product "${productRow.name}" is inactive and cannot be ordered.',
        );
      }
      if (categoryRow != null && !categoryRow.isActive) {
        throw Exception(
          'Category "${categoryRow.name}" for product "${productRow.name}" is inactive and cannot be ordered.',
        );
      }

      final stockRow = await stockRepo.getByProductAndStore(
        storeId: storeId,
        productId: productId,
      );

      if (stockRow != null && stockRow.quantity < quantity) {
        throw Exception(
          'Insufficient stock for product "${productRow.name}". Available: ${stockRow.quantity}, Requested: $quantity.',
        );
      }

      resolvedItems.add((
        productId: productId,
        quantity: quantity,
        sellingPrice: productRow.sellingPrice,
        taxRate: productRow.taxRate,
        discount: discount,
      ));
    }

    return resolvedItems;
  }
}
