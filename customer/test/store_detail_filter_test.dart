import 'package:models/models.dart';
import 'package:test/test.dart';

/// Resolves active category id safely against a store category list.
String? resolveActiveCategoryId(
  String? selectedCategoryId,
  List<Category> storeCategories,
) {
  if (selectedCategoryId == null) return null;
  return storeCategories.any((c) => c.id == selectedCategoryId)
      ? selectedCategoryId
      : null;
}

/// Filters store products by resolved category and search keyword.
List<Product> filterCatalogProducts({
  required List<Product> products,
  required List<Category> storeCategories,
  String? selectedCategoryId,
  String searchQuery = '',
}) {
  final activeCatId = resolveActiveCategoryId(
    selectedCategoryId,
    storeCategories,
  );
  final query = searchQuery.trim().toLowerCase();
  return products.where((product) {
    final matchesCategory =
        activeCatId == null || product.category?.id == activeCatId;
    final matchesQuery =
        query.isEmpty ||
        product.name.toLowerCase().contains(query) ||
        (product.description?.toLowerCase().contains(query) ?? false);
    return matchesCategory && matchesQuery;
  }).toList();
}

void main() {
  group('Store Exchanging & Category Filter Reset Tests', () {
    final storeBCat1 = Category(
      id: 'cat-b-1',
      merchantId: 'merchant-b',
      storeId: 'store-b',
      name: 'Food B',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final productStoreB = Product(
      id: 'prod-b',
      merchantId: 'merchant-b',
      name: 'Cheese Burger',
      basePrice: 80.0,
      sellingPrice: 150.0,
      taxRate: 5.0,
      isActive: true,
      category: storeBCat1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('Selected category from Store A does not hide Store B products when exchanged', () {
      final storeBCategories = <Category>[storeBCat1];
      final storeBProducts = <Product>[productStoreB];

      const staleCategoryFromStoreA = 'cat-a-1';

      final resolvedCat = resolveActiveCategoryId(
        staleCategoryFromStoreA,
        storeBCategories,
      );
      expect(resolvedCat, isNull);

      final filtered = filterCatalogProducts(
        products: storeBProducts,
        storeCategories: storeBCategories,
        selectedCategoryId: staleCategoryFromStoreA,
      );

      expect(filtered.length, 1);
      expect(filtered.first.name, 'Cheese Burger');
    });

    test('Valid category in Store B correctly filters Store B products', () {
      final storeBCategories = <Category>[storeBCat1];
      final storeBProducts = <Product>[productStoreB];

      final filtered = filterCatalogProducts(
        products: storeBProducts,
        storeCategories: storeBCategories,
        selectedCategoryId: 'cat-b-1',
      );

      expect(filtered.length, 1);
      expect(filtered.first.id, productStoreB.id);
    });
  });
}
