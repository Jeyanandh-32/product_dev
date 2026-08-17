import 'package:client_repositories/client_repositories.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/products_signal.dart';

/// CRUD and stock management actions for the terminal products list.
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
    final terminal = authSignal.value.value;
    final storeId = terminal?.storeId;
    if (storeId == null) return;

    final currentProducts = productsSignal.value.value ?? [];
    productsSignal.value = const AsyncLoading();

    try {
      final product = await ProductRepository.create(
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
      );

      productsSignal.value = AsyncData([...currentProducts, product]);
    } catch (e) {
      productsSignal.value = AsyncData(currentProducts);
      rethrow;
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
      productsSignal.value = AsyncData(currentProducts);
      rethrow;
    }
  }

  static Future<void> updateStock({
    required String stockId,
    required String productId,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
  }) async {
    final currentProducts = productsSignal.value.value ?? [];
    productsSignal.value = const AsyncLoading();

    try {
      final updatedStock = await StockRepository.update(
        id: stockId,
        quantity: quantity,
        lowStockThreshold: lowStockThreshold,
        stockMonitor: stockMonitor,
      );

      productsSignal.value = AsyncData(
        currentProducts.map((p) {
          if (p.id == productId) {
            return p.copyWith(stock: updatedStock);
          }
          return p;
        }).toList(),
      );
    } catch (e) {
      productsSignal.value = AsyncData(currentProducts);
      rethrow;
    }
  }
}
