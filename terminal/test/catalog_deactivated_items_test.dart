import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';

void main() {
  group('Deactivated Products and Categories in Catalog & Cart', () {
    final activeCat = Category(
      id: 'cat-active',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Beverages',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final inactiveCat = Category(
      id: 'cat-inactive',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Discontinued',
      isActive: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final activeProduct1 = Product(
      id: 'p1',
      merchantId: 'm1',
      name: 'Active Coffee',
      basePrice: 20.0,
      sellingPrice: 50.0,
      taxRate: 5.0,
      isActive: true,
      category: activeCat,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final deactivatedProduct = Product(
      id: 'p2',
      merchantId: 'm1',
      name: 'Deactivated Tea',
      basePrice: 15.0,
      sellingPrice: 40.0,
      taxRate: 5.0,
      isActive: false,
      category: activeCat,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final productWithInactiveCat = Product(
      id: 'p3',
      merchantId: 'm1',
      name: 'Archived Soda',
      basePrice: 10.0,
      sellingPrice: 30.0,
      taxRate: 5.0,
      isActive: true,
      category: inactiveCat,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setUp(() {
      resetProductsSignal();
      resetCategoriesSignal();
      resetCartSignal();
    });

    test('filteredProductsSignal excludes deactivated products', () {
      categoriesSignal.value = AsyncData([activeCat]);
      productsSignal.value = AsyncData([activeProduct1, deactivatedProduct]);

      final filtered = filteredProductsSignal.value;
      expect(filtered.length, 1);
      expect(filtered.first.id, 'p1');
    });

    test('filteredProductsSignal excludes products in deactivated categories', () {
      categoriesSignal.value = AsyncData([activeCat, inactiveCat]);
      productsSignal.value = AsyncData([activeProduct1, productWithInactiveCat]);

      final filtered = filteredProductsSignal.value;
      expect(filtered.length, 1);
      expect(filtered.first.id, 'p1');
    });

    test('filteredProductsSignal reacts when category is deactivated', () {
      categoriesSignal.value = AsyncData([activeCat]);
      productsSignal.value = AsyncData([activeProduct1]);
      expect(filteredProductsSignal.value.length, 1);

      // Deactivate category
      categoriesSignal.value = AsyncData([activeCat.copyWith(isActive: false)]);
      expect(filteredProductsSignal.value.isEmpty, true);
    });

    test('CartController.sanitizeCart purges deactivated products and categories', () {
      CartController.addItem(activeProduct1);
      CartController.addItem(deactivatedProduct);
      CartController.addItem(productWithInactiveCat);
      expect(cartSignal.value.items.length, 3);

      // Sanitize cart with current active lists
      CartController.sanitizeCart(
        availableProducts: [activeProduct1, deactivatedProduct, productWithInactiveCat],
        availableCategories: [activeCat, inactiveCat],
      );

      expect(cartSignal.value.items.length, 1);
      expect(cartSignal.value.items.first.product.id, 'p1');
    });

    test('filteredProductsSignal applies search and active category filter', () {
      categoriesSignal.value = AsyncData([activeCat]);
      productsSignal.value = AsyncData([activeProduct1]);

      selectedCategorySignal.value = activeCat;
      searchQuerySignal.value = 'coffee';
      expect(filteredProductsSignal.value.length, 1);

      searchQuerySignal.value = 'tea';
      expect(filteredProductsSignal.value.isEmpty, true);
    });
  });
}
