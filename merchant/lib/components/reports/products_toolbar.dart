import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/reports/products_filter_bar.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:models/models.dart';

/// Top control toolbar for products sub-tab (entries selector, filter dropdowns, search, add button).
class ProductsToolbar extends StatelessComponent {
  final int entries;
  final int currentPage;
  final int totalCount;
  final Store? store;
  final bool? statusFilter;
  final bool? stockMonitorFilter;
  final ValueChanged<int> onEntryChanged;
  final ValueChanged<bool?> onStatusFilterChanged;
  final ValueChanged<bool?> onStockMonitorFilterChanged;
  final ValueChanged<String> onSearch;

  const ProductsToolbar({
    super.key,
    required this.entries,
    required this.currentPage,
    required this.totalCount,
    required this.store,
    required this.statusFilter,
    required this.stockMonitorFilter,
    required this.onEntryChanged,
    required this.onStatusFilterChanged,
    required this.onStockMonitorFilterChanged,
    required this.onSearch,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
      [
        div(
          classes: 'flex flex-wrap items-center gap-3 text-sm font-medium',
          [
            span(
              classes:
                  'flex gap-2 items-center text-sm font-medium whitespace-nowrap',
              [
                .text('Show'),
                div(classes: 'dropdown dropdown-bottom dropdown-center', [
                  div(
                    classes:
                        'btn rounded-full border border-border-medium bg-white hover:bg-base-200 text-sm h-8 min-h-0',
                    attributes: {
                      'tabindex': '0',
                      'role': 'button',
                    },
                    [
                      .text('$entries'),
                      ChevronDown(classes: 'w-4 h-4'),
                    ],
                  ),
                  ul(
                    attributes: {'tabindex': '-1'},
                    classes:
                        'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 p-2 shadow-sm border border-border-light',
                    [
                      for (final count in [10, 25, 50, 100])
                        li([
                          button(
                            classes:
                                'text-sm ${entries == count ? 'active' : ''}',
                            onClick: () => onEntryChanged(count),
                            [.text('$count')],
                          ),
                        ]),
                    ],
                  ),
                ]),
                if (totalCount > 0)
                  .text(
                    'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, totalCount)} of $totalCount',
                  ),
              ],
            ),
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
                onClick: () {
                  editingProductSignal.value = null;
                  activeModalSignal.value = ActiveModal.addProduct;
                },
              ),
          ],
        ),
      ],
    );
  }
}
