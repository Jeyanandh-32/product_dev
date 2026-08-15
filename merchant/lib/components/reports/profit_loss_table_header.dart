import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/sortable_header.dart';

/// Sort keys for profit and loss report data table.
enum ProfitLossSortKey {
  name,
  category,
  counter,
  soldQuantity,
  costPrice,
  collectedPrice,
  profit,
  percentage,
}

/// Table header for merchant Profit & Loss analytics table.
class ProfitLossTableHeader extends StatelessComponent {
  final SortState<ProfitLossSortKey> sortState;
  final ValueChanged<ProfitLossSortKey> onSort;

  const ProfitLossTableHeader({
    super.key,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    return thead([
      tr([
        th([]),
        SortableHeader<ProfitLossSortKey>(
          title: 'Product Name',
          sortKey: ProfitLossSortKey.name,
          currentSort: sortState,
          onSort: onSort,
          isTh: true,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Category',
          sortKey: ProfitLossSortKey.category,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Counter',
          sortKey: ProfitLossSortKey.counter,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Sold Qty',
          sortKey: ProfitLossSortKey.soldQuantity,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Cost Price (₹)',
          sortKey: ProfitLossSortKey.costPrice,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Collected Price (₹)',
          sortKey: ProfitLossSortKey.collectedPrice,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Profit / Loss (₹)',
          sortKey: ProfitLossSortKey.profit,
          currentSort: sortState,
          onSort: onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Margin (%)',
          sortKey: ProfitLossSortKey.percentage,
          currentSort: sortState,
          onSort: onSort,
        ),
        th([]),
      ]),
    ]);
  }
}
