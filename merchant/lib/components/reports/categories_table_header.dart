import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/sortable_header.dart';

/// Sortable columns for merchant categories table.
enum CategorySortKey { name, status, productsCount, description }

/// Table header component for categories subtab.
class CategoriesTableHeader extends StatelessComponent {
  final SortState<CategorySortKey> sortState;
  final ValueChanged<CategorySortKey> onSort;

  const CategoriesTableHeader({
    super.key,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    return thead([
      tr([
        th([]),
        td([.text('Action')]),
        td([.text('Image')]),
        SortableHeader<CategorySortKey>(
          title: 'Name',
          sortKey: CategorySortKey.name,
          currentSort: sortState,
          onSort: onSort,
          isTh: true,
        ),
        SortableHeader<CategorySortKey>(
          title: 'Status',
          sortKey: CategorySortKey.status,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<CategorySortKey>(
          title: 'Associated Products',
          sortKey: CategorySortKey.productsCount,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<CategorySortKey>(
          title: 'Description',
          sortKey: CategorySortKey.description,
          currentSort: sortState,
          onSort: onSort,
        ),
        th([]),
      ]),
    ]);
  }
}
