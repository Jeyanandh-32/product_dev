import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/reports/orders_filter_bar.dart';
import 'package:merchant/components/reports/stats_toggle_button.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/orders_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';

/// Top control toolbar for orders sub-tab (entries selector, date range, status filters, stats toggle, and search).
class OrdersToolbar extends StatelessComponent {
  final int entries;
  final int currentPage;
  final int totalCount;
  final ValueChanged<int> onEntryChanged;
  final ValueChanged<String> onSearch;

  const OrdersToolbar({
    super.key,
    required this.entries,
    required this.currentPage,
    required this.totalCount,
    required this.onEntryChanged,
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
            DateRangePicker(
              fromDate: reportsFromDateSignal.value,
              toDate: reportsToDateSignal.value,
              onChanged: (from, to) {
                reportsFromDateSignal.value = from;
                reportsToDateSignal.value = to;
                ordersPageSignal.value = 1;
                refreshOrdersSignal();
              },
            ),
            OrdersFilterBar(
              onFiltersChanged: () {
                ordersPageSignal.value = 1;
                refreshOrdersSignal();
              },
            ),
            StatsToggleButton(
              showStats: showReportsStatsSignal.value,
              onToggle: () {
                showReportsStatsSignal.value = !showReportsStatsSignal.value;
              },
            ),
          ],
        ),
        div(
          classes: 'flex justify-between gap-2 items-center w-full sm:w-auto',
          [
            Searchbar(
              placeholder: 'Search Orders...',
              classes: 'flex-1 sm:flex-none sm:w-64',
              onInput: onSearch,
            ),
          ],
        ),
      ],
    );
  }
}
