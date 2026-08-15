import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/recent_stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Data service for fetching store catalog details, products, and categories.
class StoreDetailLoader {
  const StoreDetailLoader._();

  static Future<void> loadStoreData({
    required String slug,
    required AsyncSignal<Store?> storeSignal,
    required AsyncSignal<List<Product>> productsSignal,
    required AsyncSignal<List<Category>> categoriesSignal,
  }) async {
    try {
      final store = await StoreRepository.getBySlug(slug);
      storeSignal.value = AsyncData(store);

      if (store != null) {
        setActiveStore(store);
        recordStoreVisitSignal(store.id);
        await Future.wait([
          loadCategories(store.id, categoriesSignal),
          loadProducts(store.id, productsSignal),
        ]);
      } else {
        productsSignal.value = const AsyncData([]);
        categoriesSignal.value = const AsyncData([]);
      }
    } catch (e, stack) {
      storeSignal.value = AsyncError(e, stack);
      productsSignal.value = AsyncError(e, stack);
      categoriesSignal.value = AsyncError(e, stack);
    }
  }

  static Future<void> loadCategories(
    String storeId,
    AsyncSignal<List<Category>> categoriesSignal,
  ) async {
    try {
      final categoriesRes = await CategoryRepository.getAll(
        storeId: storeId,
        size: 100,
      );
      categoriesSignal.value = AsyncData(categoriesRes.items);
    } catch (e, stack) {
      categoriesSignal.value = AsyncError(e, stack);
    }
  }

  static Future<void> loadProducts(
    String storeId,
    AsyncSignal<List<Product>> productsSignal,
  ) async {
    try {
      final productsRes = await ProductRepository.getAll(
        storeId: storeId,
        size: 200,
      );
      productsSignal.value = AsyncData(productsRes.items);
    } catch (e, stack) {
      productsSignal.value = AsyncError(e, stack);
    }
  }
}
