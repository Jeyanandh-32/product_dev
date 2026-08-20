import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';

void main() {
  final now = DateTime.now();
  final cat1 = Category(id: 'c1', name: 'Coffee & Tea', merchantId: 'm1', storeId: 's1', description: 'Hot & cold brewed beverages', isActive: true, createdAt: now.subtract(const Duration(days: 2)), updatedAt: now);
  final cat2 = Category(id: 'c2', name: 'Bakery', merchantId: 'm1', storeId: 's1', description: 'Fresh croissants & cookies', isActive: false, createdAt: now.subtract(const Duration(days: 1)), updatedAt: now);
  final cat3 = Category(id: 'c3', name: 'Desserts', merchantId: 'm1', storeId: 's1', description: 'Cakes and pastries', isActive: true, createdAt: now, updatedAt: now);

  final p1 = Product(id: 'p1', merchantId: 'm1', name: 'Espresso', category: cat1, taxRate: 5.0, basePrice: 80.0, sellingPrice: 120.0, isActive: true, createdAt: now, updatedAt: now);
  final p2 = Product(id: 'p2', merchantId: 'm1', name: 'Latte', category: cat1, taxRate: 5.0, basePrice: 100.0, sellingPrice: 150.0, isActive: true, createdAt: now, updatedAt: now);
  final p3 = Product(id: 'p3', merchantId: 'm1', name: 'Croissant', category: cat2, taxRate: 5.0, basePrice: 50.0, sellingPrice: 80.0, isActive: true, createdAt: now, updatedAt: now);

  setUp(() {
    categoriesSignal.value = AsyncData([cat1, cat2, cat3]);
    productsSignal.value = AsyncData([p1, p2, p3]);
    categorySearchSignal.value = '';
    categoryStatusFilterSignal.value = null;
    categorySortStateSignal.value = const CategorySortState();
    categoryEntriesSignal.value = 10;
    categoryPageSignal.value = 1;
  });

  test('filteredCategoriesSignal returns all categories when no filters applied', () {
    expect(filteredCategoriesSignal.value.length, 3);
  });

  test('categorySearchSignal filters by name or description', () {
    categorySearchSignal.value = 'tea';
    expect(filteredCategoriesSignal.value.map((c) => c.name), ['Coffee & Tea']);

    categorySearchSignal.value = 'pastries';
    expect(filteredCategoriesSignal.value.map((c) => c.name), ['Desserts']);
  });

  test('categoryStatusFilterSignal filters active/inactive categories', () {
    categoryStatusFilterSignal.value = true;
    expect(filteredCategoriesSignal.value.map((c) => c.name), ['Coffee & Tea', 'Desserts']);

    categoryStatusFilterSignal.value = false;
    expect(filteredCategoriesSignal.value.map((c) => c.name), ['Bakery']);
  });

  test('categorySortStateSignal sorts by name, status, productCount, and description', () {
    categorySortStateSignal.value = const CategorySortState(key: CategorySortKey.name, isAscending: true);
    expect(filteredCategoriesSignal.value.map((c) => c.name), ['Bakery', 'Coffee & Tea', 'Desserts']);

    categorySortStateSignal.value = const CategorySortState(key: CategorySortKey.productCount, isAscending: false);
    expect(filteredCategoriesSignal.value.first.name, 'Coffee & Tea'); // 2 products

    categorySortStateSignal.value = const CategorySortState(key: CategorySortKey.description, isAscending: true);
    expect(filteredCategoriesSignal.value.map((c) => c.name), ['Desserts', 'Bakery', 'Coffee & Tea']);
  });

  test('category pagination computes correctly', () {
    categoryEntriesSignal.value = 2;
    categoryPageSignal.value = 1;
    expect(pagedCategoriesSignal.value.length, 2);
    expect(categoryTotalPagesSignal.value, 2);

    categoryPageSignal.value = 2;
    expect(pagedCategoriesSignal.value.length, 1);
  });
}
