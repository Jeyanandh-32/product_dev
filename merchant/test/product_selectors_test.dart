import 'package:merchant/components/fields/category_selector_field.dart';
import 'package:merchant/components/fields/counter_selector_field.dart';
import 'package:merchant/components/modals/add_edit_product_modal.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  group('CategorySelectorField Tests', () {
    final sampleCategory = Category(
      id: 'cat-1',
      merchantId: 'm-1',
      storeId: 'store-1',
      name: 'Beverages',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    test(
      'CategorySelectorField initializes with categories and empty selection',
      () {
        String selectedId = '';
        final field = CategorySelectorField(
          categoryId: '',
          categories: [sampleCategory],
          onSelect: (val) => selectedId = val,
        );

        expect(field.categoryId, isEmpty);
        expect(field.categories.length, equals(1));
        expect(field.categories.first.name, equals('Beverages'));

        field.onSelect('cat-1');
        expect(selectedId, equals('cat-1'));
      },
    );

    test('CategorySelectorField initializes with empty category list', () {
      final field = CategorySelectorField(
        categoryId: '',
        categories: const [],
        onSelect: (_) {},
      );

      expect(field.categories, isEmpty);
    });
  });

  group('CounterSelectorField Tests', () {
    final sampleCounter = Counter(
      id: 'counter-1',
      merchantId: 'm-1',
      storeId: 'store-1',
      name: 'Checkout 1',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    test(
      'CounterSelectorField initializes with counters and selection callback',
      () {
        String selectedCounterId = '';
        final field = CounterSelectorField(
          counterId: 'counter-1',
          counters: [sampleCounter],
          onSelect: (val) => selectedCounterId = val,
        );

        expect(field.counterId, equals('counter-1'));
        expect(field.counters.length, equals(1));
        expect(field.counters.first.name, equals('Checkout 1'));

        field.onSelect('');
        expect(selectedCounterId, isEmpty);
      },
    );

    test('CounterSelectorField initializes with empty counters list', () {
      final field = CounterSelectorField(
        counterId: '',
        counters: const [],
        onSelect: (_) {},
      );

      expect(field.counters, isEmpty);
    });
  });

  group('AddEditProductModal Tests', () {
    test('AddEditProductModal instantiates without product', () {
      const modal = AddEditProductModal();
      expect(modal.product, isNull);
    });

    test('Categories and Counters signal refresh with null store produces empty list', () async {
      storeSignal.value = null;
      await refreshCategoriesSignal(customSize: 1000, ignoreSearch: true);
      await refreshCountersSignal(customSize: 1000, ignoreSearch: true);

      expect(categoriesSignal.value.value, equals([]));
      expect(countersSignal.value.value, equals([]));
    });
  });
}
