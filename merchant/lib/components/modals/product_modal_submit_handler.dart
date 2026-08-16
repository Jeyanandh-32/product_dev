import 'package:merchant/signals/products_signal.dart';
import 'package:models/models.dart';

/// Form submission handler for Product create and update operations.
class ProductModalSubmitHandler {
  const ProductModalSubmitHandler._();

  static void submit({
    required Product? product,
    required String name,
    required String categoryId,
    required String counterId,
    required String basePriceStr,
    required String sellingPriceStr,
    required String taxRateStr,
    required String sku,
    required String barcode,
    required String imageUrl,
    required bool isActive,
  }) {
    final basePrice = double.tryParse(basePriceStr.trim()) ?? 0.0;
    final sellingPrice = double.tryParse(sellingPriceStr.trim()) ?? 0.0;
    final taxRate = double.tryParse(taxRateStr.trim()) ?? 0.0;
    final counterIdParam = counterId.trim().isEmpty ? null : counterId;

    if (product != null) {
      ProductsActions.updateProduct(
        id: product.id,
        name: name.trim().isNotEmpty ? name : null,
        categoryId: categoryId.trim().isNotEmpty ? categoryId : null,
        counterId: counterIdParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: sku.trim().isNotEmpty ? sku : null,
        barcode: barcode.trim().isNotEmpty ? barcode : null,
        imageUrl: imageUrl.trim().isNotEmpty ? imageUrl : null,
        isActive: isActive,
      );
    } else {
      ProductsActions.create(
        name: name,
        categoryId: categoryId,
        counterId: counterIdParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: sku.trim().isNotEmpty ? sku : null,
        barcode: barcode.trim().isNotEmpty ? barcode : null,
        imageUrl: imageUrl.trim().isNotEmpty ? imageUrl : null,
      );
    }
  }
}
