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
  final categories = categoriesSignal.value.value ?? [];
  final searchQuery = searchQuerySignal.value.trim().toLowerCase();
  final selectedCategory = selectedCategorySignal.value;

  final categoryActiveMap = {
    for (final c in categories) c.id: c.isActive,
  };

  final activeProducts = products.where((product) {
    if (!product.isActive) return false;
    final catId = product.category?.id;
    if (catId != null) {
      final isCatActive = categoryActiveMap[catId] ?? product.category?.isActive ?? true;
      if (!isCatActive) return false;
    }
    return true;
  });

  return activeProducts.where((product) {
    final matchesCategory = selectedCategory == null || product.category?.id == selectedCategory.id;
    final matchesQuery = searchQuery.isEmpty ||
        product.name.toLowerCase().contains(searchQuery) ||
        (product.sku?.toLowerCase().contains(searchQuery) ?? false) ||
        (product.barcode?.toLowerCase().contains(searchQuery) ?? false);
    return matchesCategory && matchesQuery;
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
