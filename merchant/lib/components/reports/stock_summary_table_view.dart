import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/stock_summary_table_header.dart';
import 'package:merchant/components/reports/stock_summary_table_row.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:models/models.dart';

/// Scrollable table view of stock movement summaries with column sorting.
class StockSummaryTableView extends StatelessComponent {
  final List<StockSummaryItem> items;
  final SortState<StockSummarySortKey> sortState;
  final ValueChanged<StockSummarySortKey> onSort;

  const StockSummaryTableView({
    super.key,
    required this.items,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    final sortedItems = sortItems<StockSummaryItem, StockSummarySortKey>(
      items: items,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        StockSummarySortKey.name => item.productName.toLowerCase(),
        StockSummarySortKey.openingStock => item.openingStock,
        StockSummarySortKey.inQty => item.inQuantity,
        StockSummarySortKey.outQty => item.outQuantity,
        StockSummarySortKey.wastageQty => item.wastageQuantity,
        StockSummarySortKey.adjustmentQty => item.adjustmentQuantity,
        StockSummarySortKey.closingStock => item.closingStock,
      },
    );

    return div(classes: 'flex-1 min-h-0 overflow-auto', [
      table(
        classes: 'table table-zebra table-pin-rows table-pin-cols',
        [
          StockSummaryTableHeader(
            sortState: sortState,
            onSort: onSort,
          ),
          tbody([
            for (final item in sortedItems)
              StockSummaryTableRow(item: item),
          ]),
        ],
      ),
    ]);
  }
}
