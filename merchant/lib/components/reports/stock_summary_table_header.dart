import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/sortable_header.dart';

/// Sort keys for stock summary report data table.
enum StockSummarySortKey {
  name,
  openingStock,
  inQty,
  outQty,
  wastageQty,
  adjustmentQty,
  closingStock,
}

/// Table header for merchant stock summary table.
class StockSummaryTableHeader extends StatelessComponent {
  final SortState<StockSummarySortKey> sortState;
  final ValueChanged<StockSummarySortKey> onSort;

  const StockSummaryTableHeader({
    super.key,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    return thead([
      tr([
        th([]),
        SortableHeader<StockSummarySortKey>(
          title: 'Product Name',
          sortKey: StockSummarySortKey.name,
          currentSort: sortState,
          onSort: onSort,
          isTh: true,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Opening Stock',
          sortKey: StockSummarySortKey.openingStock,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'In Quantity',
          sortKey: StockSummarySortKey.inQty,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Out Quantity',
          sortKey: StockSummarySortKey.outQty,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Wastage',
          sortKey: StockSummarySortKey.wastageQty,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Adjustment',
          sortKey: StockSummarySortKey.adjustmentQty,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Closing Stock',
          sortKey: StockSummarySortKey.closingStock,
          currentSort: sortState,
          onSort: onSort,
        ),
        th([]),
      ]),
    ]);
  }
}
