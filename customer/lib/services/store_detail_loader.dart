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
    storeSignal.value = const AsyncLoading();
    productsSignal.value = const AsyncLoading();
    categoriesSignal.value = const AsyncLoading();

    try {
      final store = await StoreRepository.getBySlug(slug);
      if (store != null) {
        setActiveStore(store);
        recordStoreVisitSignal(store.id);
        storeSignal.value = AsyncData(store);

        final categoriesFuture = CategoryRepository.getAll(
          storeId: store.id,
          isActive: true,
          size: 100,
        ).then((res) => res.items).catchError((_) => <Category>[]);

        final productsFuture = ProductRepository.getAll(
          storeId: store.id,
          isActive: true,
          size: 200,
        ).then((res) => res.items).catchError((_) => <Product>[]);

        final (cats, prods) = await (categoriesFuture, productsFuture).wait;
        categoriesSignal.value = AsyncData(cats);
        productsSignal.value = AsyncData(prods);
      } else {
        storeSignal.value = const AsyncData(null);
        productsSignal.value = const AsyncData([]);
        categoriesSignal.value = const AsyncData([]);
      }
    } catch (e, stack) {
      storeSignal.value = AsyncError(e, stack);
      productsSignal.value = AsyncError(e, stack);
      categoriesSignal.value = AsyncError(e, stack);
    }
  }
}
