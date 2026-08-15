import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/profit_loss_table_header.dart';
import 'package:merchant/components/reports/profit_loss_table_row.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:models/models.dart';

/// Scrollable table view of profit & loss line items with column sorting.
class ProfitLossTableView extends StatelessComponent {
  final List<ProfitLossItem> items;
  final SortState<ProfitLossSortKey> sortState;
  final ValueChanged<ProfitLossSortKey> onSort;

  const ProfitLossTableView({
    super.key,
    required this.items,
    required this.sortState,
    required this.onSort,
  });

  @override
  Component build(BuildContext context) {
    final sortedItems = sortItems<ProfitLossItem, ProfitLossSortKey>(
      items: items,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        ProfitLossSortKey.name => item.productName.toLowerCase(),
        ProfitLossSortKey.category => item.categoryName.toLowerCase(),
        ProfitLossSortKey.counter => item.counterName.toLowerCase(),
        ProfitLossSortKey.soldQuantity => item.soldQuantity,
        ProfitLossSortKey.costPrice => item.costPrice,
        ProfitLossSortKey.collectedPrice => item.collectedPrice,
        ProfitLossSortKey.profit => item.profit,
        ProfitLossSortKey.percentage => item.profitLossPercentage,
      },
    );

    return div(classes: 'flex-1 min-h-0 overflow-auto', [
      table(
        classes: 'table table-zebra table-pin-rows table-pin-cols',
        [
          ProfitLossTableHeader(
            sortState: sortState,
            onSort: onSort,
          ),
          tbody([
            for (final item in sortedItems)
              ProfitLossTableRow(item: item),
          ]),
        ],
      ),
    ]);
  }
}
