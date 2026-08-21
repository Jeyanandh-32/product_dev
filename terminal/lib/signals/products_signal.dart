import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';

export 'products_actions.dart';

final searchQuerySignal = signal<String>('');

final productsSignal = asyncSignal<List<Product>>(const AsyncLoading());

final filteredProductsSignal = computed(() {
  final products = productsSignal.value.value ?? [];
  final searchQuery = searchQuerySignal.value;
  final selectedCategory = selectedCategorySignal.value;

  if (searchQuery.isEmpty && selectedCategory == null) return products;

  return products.where((product) {
    if (searchQuery.isNotEmpty) {
      return product.name.toLowerCase().contains(searchQuery) ||
          (product.sku?.toLowerCase().contains(searchQuery) ?? false) ||
          (product.barcode?.toLowerCase().contains(searchQuery) ?? false);
    }
    if (selectedCategory == null) return true;
    return product.category?.id == selectedCategory.id;
  }).toList();
});

Future<void>? _productsInFlight;

/// Refreshes products with in-flight deduplication to avoid redundant concurrent requests.
Future<void> refreshProductsSignal() async {
  if (_productsInFlight != null) return _productsInFlight!;
  final future = _fetchProducts();
  _productsInFlight = future;
  try {
    await future;
  } finally {
    _productsInFlight = null;
  }
}

Future<void> _fetchProducts() async {
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

/// Resets search query and product cache to initial state.
void resetProductsSignal() {
  searchQuerySignal.value = '';
  productsSignal.value = const AsyncLoading();
}
