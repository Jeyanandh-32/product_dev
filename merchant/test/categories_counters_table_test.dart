import 'package:merchant/components/reports/categories_table_header.dart';
import 'package:merchant/components/reports/categories_table_view.dart';
import 'package:merchant/components/reports/counters_table_header.dart';
import 'package:merchant/components/reports/counters_table_view.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  group('CategoriesTableView & CountersTableView Construction Tests', () {
    test('CategoriesTableView instantiates with sort and filters', () {
      final categories = [
        Category(
          id: 'cat-1',
          merchantId: 'm-1',
          storeId: 's-1',
          name: 'Coffee',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final tableView = CategoriesTableView(
        categories: categories,
        sortState: const SortState<CategorySortKey>(),
        onSort: (_) {},
        getAssociatedCount: (_) => 5,
      );

      expect(tableView.categories.length, 1);
      expect(tableView.getAssociatedCount(categories.first), 5);
    });

    test('CountersTableView instantiates with sort and filters', () {
      final counters = [
        Counter(
          id: 'cnt-1',
          merchantId: 'm-1',
          storeId: 'store-1',
          name: 'Counter 1',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final tableView = CountersTableView(
        counters: counters,
        sortState: const SortState<CounterSortKey>(),
        onSort: (_) {},
        getAssociatedCount: (_) => 3,
      );

      expect(tableView.counters.length, 1);
      expect(tableView.getAssociatedCount(counters.first), 3);
    });
  });
}
