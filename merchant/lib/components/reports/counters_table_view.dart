import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/counter_table_row.dart';
import 'package:merchant/components/reports/counters_table_header.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';

/// Scrollable table view of counters with sorting and edit action triggers.
class CountersTableView extends StatelessComponent {
  final List<Counter> counters;
  final SortState<CounterSortKey> sortState;
  final ValueChanged<CounterSortKey> onSort;
  final bool? statusFilter;
  final int Function(Counter) getAssociatedCount;

  const CountersTableView({
    super.key,
    required this.counters,
    required this.sortState,
    required this.onSort,
    this.statusFilter,
    required this.getAssociatedCount,
  });

  @override
  Component build(BuildContext context) {
    final filtered = counters.where((cnt) {
      if (statusFilter != null && cnt.isActive != statusFilter) {
        return false;
      }
      return true;
    }).toList();

    final sortedCounters = sortItems<Counter, CounterSortKey>(
      items: filtered,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        CounterSortKey.name => item.name.toLowerCase(),
        CounterSortKey.status => item.isActive ? 1 : 0,
        CounterSortKey.productsCount => getAssociatedCount(item),
        CounterSortKey.description => (item.description ?? '').toLowerCase(),
      },
    );

    return div(classes: 'flex-1 min-h-0 overflow-auto', [
      table(
        classes: 'table table-zebra table-pin-rows table-pin-cols',
        [
          CountersTableHeader(
            sortState: sortState,
            onSort: onSort,
          ),
          tbody([
            for (final counter in sortedCounters)
              CounterTableRow(
                counter: counter,
                productsCount: getAssociatedCount(counter),
                onEdit: () {
                  editingCounterSignal.value = counter;
                  activeModalSignal.value = ActiveModal.editCounter;
                },
              ),
          ]),
        ],
      ),
    ]);
  }
}
