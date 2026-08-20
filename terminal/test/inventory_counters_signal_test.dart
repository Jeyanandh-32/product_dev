import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
import 'package:terminal/signals/products_signal.dart';

void main() {
  final now = DateTime.now();
  final c1 = Counter(id: 'cnt1', name: 'Main Bar', merchantId: 'm1', storeId: 's1', description: 'Front bar drinks counter', isActive: true, createdAt: now.subtract(const Duration(days: 2)), updatedAt: now);
  final c2 = Counter(id: 'cnt2', name: 'Kitchen Counter', merchantId: 'm1', storeId: 's1', description: 'Hot kitchen prep station', isActive: false, createdAt: now.subtract(const Duration(days: 1)), updatedAt: now);
  final c3 = Counter(id: 'cnt3', name: 'Dessert Station', merchantId: 'm1', storeId: 's1', description: 'Pastries & cakes display', isActive: true, createdAt: now, updatedAt: now);

  final p1 = Product(id: 'p1', merchantId: 'm1', name: 'Espresso', counter: c1, taxRate: 5.0, basePrice: 80.0, sellingPrice: 120.0, isActive: true, createdAt: now, updatedAt: now);
  final p2 = Product(id: 'p2', merchantId: 'm1', name: 'Latte', counter: c1, taxRate: 5.0, basePrice: 100.0, sellingPrice: 150.0, isActive: true, createdAt: now, updatedAt: now);
  final p3 = Product(id: 'p3', merchantId: 'm1', name: 'Burger', counter: c2, taxRate: 5.0, basePrice: 150.0, sellingPrice: 220.0, isActive: true, createdAt: now, updatedAt: now);

  setUp(() {
    countersSignal.value = AsyncData([c1, c2, c3]);
    productsSignal.value = AsyncData([p1, p2, p3]);
    counterSearchSignal.value = '';
    counterStatusFilterSignal.value = null;
    counterSortStateSignal.value = const CounterSortState();
    counterEntriesSignal.value = 10;
    counterPageSignal.value = 1;
  });

  test('filteredCountersSignal returns all counters when no filters applied', () {
    expect(filteredCountersSignal.value.length, 3);
  });

  test('counterSearchSignal filters by name or description', () {
    counterSearchSignal.value = 'bar';
    expect(filteredCountersSignal.value.map((c) => c.name), ['Main Bar']);

    counterSearchSignal.value = 'prep';
    expect(filteredCountersSignal.value.map((c) => c.name), ['Kitchen Counter']);
  });

  test('counterStatusFilterSignal filters active/inactive counters', () {
    counterStatusFilterSignal.value = true;
    expect(filteredCountersSignal.value.map((c) => c.name), ['Main Bar', 'Dessert Station']);

    counterStatusFilterSignal.value = false;
    expect(filteredCountersSignal.value.map((c) => c.name), ['Kitchen Counter']);
  });

  test('counterSortStateSignal sorts by name, status, productCount, and description', () {
    counterSortStateSignal.value = const CounterSortState(key: CounterSortKey.name, isAscending: true);
    expect(filteredCountersSignal.value.map((c) => c.name), ['Dessert Station', 'Kitchen Counter', 'Main Bar']);

    counterSortStateSignal.value = const CounterSortState(key: CounterSortKey.productCount, isAscending: false);
    expect(filteredCountersSignal.value.first.name, 'Main Bar'); // 2 products

    counterSortStateSignal.value = const CounterSortState(key: CounterSortKey.description, isAscending: true);
    expect(filteredCountersSignal.value.map((c) => c.name), ['Main Bar', 'Kitchen Counter', 'Dessert Station']);
  });

  test('counter pagination computes correctly', () {
    counterEntriesSignal.value = 2;
    counterPageSignal.value = 1;
    expect(pagedCountersSignal.value.length, 2);
    expect(counterTotalPagesSignal.value, 2);

    counterPageSignal.value = 2;
    expect(pagedCountersSignal.value.length, 1);
  });
}
