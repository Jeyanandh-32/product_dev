import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/reports/products_filter_bar.dart';
import 'package:models/models.dart';

/// Top control toolbar for products sub-tab (filter dropdowns, search, add button).
class ProductsToolbar extends StatelessComponent {
  final Store? store;
  final bool? statusFilter;
  final bool? stockMonitorFilter;
  final ValueChanged<bool?> onStatusFilterChanged;
  final ValueChanged<bool?> onStockMonitorFilterChanged;
  final ValueChanged<String> onSearch;
  final VoidCallback onAddProduct;

  const ProductsToolbar({
    super.key,
    required this.store,
    required this.statusFilter,
    required this.stockMonitorFilter,
    required this.onStatusFilterChanged,
    required this.onStockMonitorFilterChanged,
    required this.onSearch,
    required this.onAddProduct,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
      [
        div(
          classes: 'flex flex-wrap items-center gap-3 text-sm font-medium',
          [
            ProductsFilterBar(
              statusFilter: statusFilter,
              stockMonitorFilter: stockMonitorFilter,
              onStatusFilterChanged: onStatusFilterChanged,
              onStockMonitorFilterChanged: onStockMonitorFilterChanged,
            ),
          ],
        ),
        div(
          classes: 'flex justify-between gap-2 items-center w-full sm:w-auto',
          [
            Searchbar(
              placeholder: 'Search Products...',
              classes: 'flex-1 sm:flex-none sm:w-64',
              onInput: onSearch,
            ),
            if (store != null)
              AddButton(
                name: 'Add Product',
                onClick: onAddProduct,
              ),
          ],
        ),
      ],
    );
  }
}
