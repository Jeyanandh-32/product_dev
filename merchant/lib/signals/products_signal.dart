import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stock_summary_signal.dart';
import 'package:merchant/signals/stores_signal.dart';

import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final productsPageSignal = signal<int>(1);
final productsTotalSignal = signal<int>(0);
final productsTotalPagesSignal = signal<int>(1);
final productSearchSignal = signal<String>('');
final editingProductSignal = signal<Product?>(null);

final productsSignal = asyncSignal<List<Product>>(const AsyncLoading());

Future<void> refreshProductsSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    productsSignal.value = const AsyncData([]);
    return;
  }

  productsSignal.value = const AsyncLoading();

  final size = entriesSignal.value;
  final page = productsPageSignal.value;

  try {
    final search = productSearchSignal.value.trim();

    final result = await ProductRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
      search: search.isNotEmpty ? search : null,
    );

    productsTotalSignal.value = result.totalItems;
    productsTotalPagesSignal.value = result.totalPages;
    productsSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    productsSignal.value = AsyncError(e, stack);
  }
}

abstract final class ProductsActions {
  static Future<void> create({
    required String name,
    required String categoryId,
    required String counterId,
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

      productsSignal.value = AsyncData([...currentProducts, product]);
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
