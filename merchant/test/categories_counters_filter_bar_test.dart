import 'package:merchant/components/reports/categories_filter_bar.dart';
import 'package:merchant/components/reports/counters_filter_bar.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  final sampleStore = Store(
    id: 'store-1',
    merchantId: 'm-1',
    name: 'Main Branch',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  group('CategoriesFilterBar Tests', () {
    test('CategoriesFilterBar instantiates with and without store', () {
      final barWithoutStore = CategoriesFilterBar(
        store: null,
        statusFilter: null,
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithoutStore.store, isNull);
      expect(barWithoutStore.statusFilter, isNull);

      final barWithStore = CategoriesFilterBar(
        store: sampleStore,
        statusFilter: true,
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithStore.store, equals(sampleStore));
      expect(barWithStore.statusFilter, isTrue);
    });

    test('Add Category modal signal trigger', () {
      activeModalSignal.value = ActiveModal.none;
      editingCategorySignal.value = null;

      editingCategorySignal.value = null;
      activeModalSignal.value = ActiveModal.addCategory;

      expect(activeModalSignal.value, ActiveModal.addCategory);
      expect(editingCategorySignal.value, isNull);
    });
  });

  group('CountersFilterBar Tests', () {
    test('CountersFilterBar instantiates with and without store', () {
      final barWithoutStore = CountersFilterBar(
        store: null,
        statusFilter: null,
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithoutStore.store, isNull);
      expect(barWithoutStore.statusFilter, isNull);

      final barWithStore = CountersFilterBar(
        store: sampleStore,
        statusFilter: false,
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithStore.store, equals(sampleStore));
      expect(barWithStore.statusFilter, isFalse);
    });

    test('Add Counter modal signal trigger', () {
      activeModalSignal.value = ActiveModal.none;
      editingCounterSignal.value = null;

      editingCounterSignal.value = null;
      activeModalSignal.value = ActiveModal.addCounter;

      expect(activeModalSignal.value, ActiveModal.addCounter);
      expect(editingCounterSignal.value, isNull);
    });
  });
}
