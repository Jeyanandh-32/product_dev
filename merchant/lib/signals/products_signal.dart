import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

export 'package:merchant/signals/products_actions.dart';

final productsPageSignal = signal<int>(1);
final productsTotalSignal = signal<int>(0);
final productsTotalPagesSignal = signal<int>(1);
final productSearchSignal = signal<String>('');
final editingProductSignal = signal<Product?>(null);

final productsSignal = asyncSignal<List<Product>>(const AsyncLoading());
final allStoreProductsSignal = asyncSignal<List<Product>>(const AsyncLoading());

void resetProductsSignal() {
  productsPageSignal.value = 1;
  productsTotalSignal.value = 0;
  productsTotalPagesSignal.value = 1;
  productSearchSignal.value = '';
  editingProductSignal.value = null;
  productsSignal.value = const AsyncData([]);
  allStoreProductsSignal.value = const AsyncData([]);
}

Future<void> fetchAllStoreProductsSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    allStoreProductsSignal.value = const AsyncData([]);
    return;
  }

  allStoreProductsSignal.value = const AsyncLoading();

  try {
    final result = await ProductRepository.getAll(
      storeId: selectedStore.id,
      page: 1,
      size: 1000,
    );
    allStoreProductsSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    allStoreProductsSignal.value = AsyncError(e, stack);
  }
}

Future<void> refreshProductsSignal({int? customSize}) async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    productsSignal.value = const AsyncData([]);
    return;
  }

  productsSignal.value = const AsyncLoading();

  final size = customSize ?? entriesSignal.value;
  final page = customSize != null ? 1 : productsPageSignal.value;

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
