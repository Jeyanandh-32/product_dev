import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/stock_summary_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Product actions executor handling create, update, and stock modification.
abstract final class ProductsActions {
  static Future<void> create({
    required String name,
    required String categoryId,
    String? counterId,
    required double basePrice,
    required double sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    final selectedStore = storeSignal.value;
    if (selectedStore == null) return;

    final currentProducts = productsSignal.value.value ?? [];
    productsSignal.value = const AsyncLoading();

    try {
      final product = await ProductRepository.create(
        storeId: selectedStore.id,
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
      );

      productsTotalSignal.value = productsTotalSignal.value + 1;
      productsSignal.value = AsyncData([...currentProducts, product]);
      showToast('Product created successfully.', type: ToastType.success);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      productsSignal.value = AsyncData(currentProducts);
    }
  }

  static Future<void> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    String? counterId,
    bool? isActive,
    double? basePrice,
    double? sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    final currentProducts = productsSignal.value.value ?? [];
    productsSignal.value = const AsyncLoading();

    try {
      final updatedProduct = await ProductRepository.update(
        id: id,
        name: name,
        categoryId: categoryId,
        counterId: counterId,
        isActive: isActive,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: sku,
        barcode: barcode,
        description: description,
        imageUrl: imageUrl,
      );

      productsSignal.value = AsyncData(
        currentProducts.map((p) => p.id == id ? updatedProduct : p).toList(),
      );
      showToast('Product updated successfully.', type: ToastType.success);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      productsSignal.value = AsyncData(currentProducts);
    }
  }

  static Future<void> updateStock({
    required String stockId,
    required String productId,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
    StockTransactionType? transactionType,
    int? amount,
    StockTransactionReason? reason,
    String? customReason,
  }) async {
    final currentProducts = productsSignal.value.value ?? [];
    productsSignal.value = const AsyncLoading();

    try {
      await StockRepository.update(
        id: stockId,
        quantity: quantity,
        lowStockThreshold: lowStockThreshold,
        stockMonitor: stockMonitor,
        transactionType: transactionType,
        amount: amount,
        reason: reason,
        customReason: customReason,
      );

      await refreshProductsSignal();
      refreshStockSummarySignal();
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      productsSignal.value = AsyncData(currentProducts);
    }
  }
}
