import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/categories_table_header.dart';
import 'package:merchant/components/reports/category_table_row.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';

/// Scrollable table view of categories with sorting and edit action triggers.
class CategoriesTableView extends StatelessComponent {
  final List<Category> categories;
  final SortState<CategorySortKey> sortState;
  final ValueChanged<CategorySortKey> onSort;
  final bool? statusFilter;
  final int Function(Category) getAssociatedCount;

  const CategoriesTableView({
    super.key,
    required this.categories,
    required this.sortState,
    required this.onSort,
    this.statusFilter,
    required this.getAssociatedCount,
  });

  @override
  Component build(BuildContext context) {
    final filtered = categories.where((cat) {
      if (statusFilter != null && cat.isActive != statusFilter) {
        return false;
      }
      return true;
    }).toList();

    final sortedCategories = sortItems<Category, CategorySortKey>(
      items: filtered,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        CategorySortKey.name => item.name.toLowerCase(),
        CategorySortKey.status => item.isActive ? 1 : 0,
        CategorySortKey.productsCount => getAssociatedCount(item),
        CategorySortKey.description => (item.description ?? '').toLowerCase(),
      },
    );

    return div(classes: 'flex-1 min-h-0 overflow-auto', [
      table(
        classes: 'table table-zebra table-pin-rows table-pin-cols',
        [
          CategoriesTableHeader(
            sortState: sortState,
            onSort: onSort,
          ),
          tbody([
            for (final category in sortedCategories)
              CategoryTableRow(
                category: category,
                productsCount: getAssociatedCount(category),
                onEdit: () {
                  editingCategorySignal.value = category;
                  activeModalSignal.value = ActiveModal.editCategory;
                },
              ),
          ]),
        ],
      ),
    ]);
  }
}
