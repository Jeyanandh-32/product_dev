import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:terminal/providers/auth_provider.dart';
import 'package:terminal/repositories/product_repository.dart';
import 'package:terminal/repositories/stock_repository.dart';

final productsProvider =
    AsyncNotifierProvider.autoDispose<ProductsProvider, List<Product>>(
      () => ProductsProvider(),
    );

class ProductsProvider extends AsyncNotifier<List<Product>> {
  @override
  FutureOr<List<Product>> build() async {
    final terminal = ref.watch(authProvider);
    final storeId = terminal.value?.storeId;
    if (storeId == null) return [];

    try {
      final (products, _) = await ProductRepository.getAll(
        storeId: storeId,
      );

      return products;
    } catch (e) {
      return [];
    }
  }

  Future<void> create({
    required String name,
    required String categoryId,
    required String counterId,
    required int basePrice,
    required int sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    final terminal = ref.read(authProvider);
    final storeId = terminal.value?.storeId;
    if (storeId == null) return;

    final currentProducts = state.value ?? [];
    state = const AsyncLoading();

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

      state = AsyncData([...currentProducts, product]);
    } catch (e) {
      state = AsyncData(currentProducts);
      rethrow;
    }
  }

  Future<void> updateProduct({
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
  }) async {
    final currentProducts = state.value ?? [];
    state = const AsyncLoading();

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

      state = AsyncData(
        currentProducts.map((p) => p.id == id ? updatedProduct : p).toList(),
      );
    } catch (e) {
      state = AsyncData(currentProducts);
      rethrow;
    }
  }

  Future<void> updateStock({
    required String stockId,
    required String productId,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
  }) async {
    final currentProducts = state.value ?? [];
    state = const AsyncLoading();

    try {
      final updatedStock = await StockRepository.update(
        id: stockId,
        quantity: quantity,
        lowStockThreshold: lowStockThreshold,
        stockMonitor: stockMonitor,
      );

      state = AsyncData(
        currentProducts.map((p) {
          if (p.id == productId) {
            return p.copyWith(stock: updatedStock);
          }
          return p;
        }).toList(),
      );
    } catch (e) {
      state = AsyncData(currentProducts);
      rethrow;
    }
  }
}
