import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/sortable_header.dart';

/// Sortable keys for merchant counters table.
enum CounterSortKey { name, status, productsCount, description }

/// Table header for merchant counters sub-tab.
class CountersTableHeader extends StatelessComponent {
  final SortState<CounterSortKey> sortState;
  final ValueChanged<CounterSortKey> onSort;

  const CountersTableHeader({
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
        SortableHeader<CounterSortKey>(
          title: 'Name',
          sortKey: CounterSortKey.name,
          currentSort: sortState,
          onSort: onSort,
          isTh: true,
        ),
        SortableHeader<CounterSortKey>(
          title: 'Status',
          sortKey: CounterSortKey.status,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<CounterSortKey>(
          title: 'Associated Products',
          sortKey: CounterSortKey.productsCount,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<CounterSortKey>(
          title: 'Description',
          sortKey: CounterSortKey.description,
          currentSort: sortState,
          onSort: onSort,
        ),
        th([]),
      ]),
    ]);
  }
}
