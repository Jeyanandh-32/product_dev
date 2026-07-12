import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/repositories/product_repository.dart';
import 'package:merchant/repositories/stock_repository.dart';
import 'package:models/models.dart';

final productsProvider =
    AsyncNotifierProvider.autoDispose<ProductsProvider, List<Product>>(
      () => ProductsProvider(),
    );

class ProductsProvider extends AsyncNotifier<List<Product>> {
  @override
  FutureOr<List<Product>> build() async {
    final selectedStore = ref.watch(storeProvider);
    if (selectedStore == null) return [];

    final size = ref.watch(entriesProvider);
    final page = ref.watch(productsPageProvider);

    try {
      final result = await ProductRepository.getAll(
        storeId: selectedStore.id,
        page: page,
        size: size,
      );

      ref.read(productsTotalProvider.notifier).state = result.totalItems;
      ref.read(productsTotalPagesProvider.notifier).state = result.totalPages;

      return result.products;
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
    final selectedStore = ref.read(storeProvider);
    if (selectedStore == null) return;

    final currentProducts = state.value ?? [];
    state = const AsyncLoading();

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

      state = AsyncData([...currentProducts, product]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentProducts);
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
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentProducts);
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
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentProducts);
    }
  }
}
