import 'package:models/models.dart';
import 'package:terminal/signals/inventory_products_signal.dart';

/// Form submission handler for Product create and update operations in Terminal.
class ProductFormSubmitHandler {
  const ProductFormSubmitHandler._();

  static Future<Product> submit({
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
  }) async {
    final basePrice = double.tryParse(basePriceStr.trim()) ?? 0.0;
    final sellingPrice = double.tryParse(sellingPriceStr.trim()) ?? 0.0;
    final taxRate = double.tryParse(taxRateStr.trim()) ?? 0.0;
    final counterParam = counterId.trim().isEmpty ? null : counterId.trim();
    final skuParam = sku.trim().isEmpty ? null : sku.trim();
    final barcodeParam = barcode.trim().isEmpty ? null : barcode.trim();
    final imageParam = imageUrl.trim().isEmpty ? null : imageUrl.trim();

    if (product != null) {
      return await InventoryStockActions.updateProduct(
        id: product.id,
        name: name.trim(),
        categoryId: categoryId.trim(),
        counterId: counterParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: skuParam,
        barcode: barcodeParam,
        imageUrl: imageParam,
        isActive: isActive,
      );
    } else {
      return await InventoryStockActions.createProduct(
        name: name.trim(),
        categoryId: categoryId.trim(),
        counterId: counterParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: skuParam,
        barcode: barcodeParam,
        imageUrl: imageParam,
      );
    }
  }
}
