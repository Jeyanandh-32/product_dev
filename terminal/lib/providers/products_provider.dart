import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/providers/auth_provider.dart';

final productsSignal = asyncSignal<List<Product>>(const AsyncLoading());

Future<void> refreshProductsSignal() async {
  final terminal = authSignal.value.value;
  final storeId = terminal?.storeId;
  if (storeId == null) {
    productsSignal.value = const AsyncData([]);
    return;
  }

  try {
    final result = await ProductRepository.getAll(storeId: storeId, size: 1000);
    productsSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    productsSignal.value = AsyncError(e, stack);
  }
}

class ProductsActions {
  const ProductsActions._();

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
