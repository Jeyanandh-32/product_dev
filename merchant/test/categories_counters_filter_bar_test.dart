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
        entries: 10,
        currentPage: 1,
        totalCount: 0,
        store: null,
        statusFilter: null,
        onEntryChanged: (_) {},
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithoutStore.store, isNull);
      expect(barWithoutStore.entries, 10);

      final barWithStore = CategoriesFilterBar(
        entries: 25,
        currentPage: 2,
        totalCount: 50,
        store: sampleStore,
        statusFilter: true,
        onEntryChanged: (_) {},
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithStore.store, equals(sampleStore));
      expect(barWithStore.totalCount, 50);
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
        entries: 10,
        currentPage: 1,
        totalCount: 0,
        store: null,
        statusFilter: null,
        onEntryChanged: (_) {},
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithoutStore.store, isNull);
      expect(barWithoutStore.entries, 10);

      final barWithStore = CountersFilterBar(
        entries: 25,
        currentPage: 2,
        totalCount: 30,
        store: sampleStore,
        statusFilter: false,
        onEntryChanged: (_) {},
        onStatusChanged: (_) {},
        onSearch: (_) {},
      );
      expect(barWithStore.store, equals(sampleStore));
      expect(barWithStore.totalCount, 30);
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
