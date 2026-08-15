import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/reports/profit_loss_summary_cards.dart';
import 'package:merchant/components/reports/profit_loss_table_header.dart';
import 'package:merchant/components/reports/profit_loss_table_view.dart';
import 'package:merchant/components/reports/stats_toggle_button.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/profit_loss_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:web/web.dart' as web;

/// Profit & Loss report sub-tab displaying cost prices, collected totals, margins, and wastage loss.
class ProfitLoss extends SignalComponent {
  const ProfitLoss({super.key});

  @override
  SignalState<ProfitLoss> createState() => _ProfitLossState();
}

class _ProfitLossState extends SignalState<ProfitLoss> {
  String? _loadedStoreId;
  SortState<ProfitLossSortKey> _sortState =
      const SortState<ProfitLossSortKey>();

  void _onSort(ProfitLossSortKey key) {
    setState(() {
      _sortState = _sortState.toggle(key);
    });
  }

  @override
  void initState() {
    super.initState();
    final store = storeSignal.value;
    if (store != null) {
      _loadedStoreId = store.id;
    }
    refreshProfitLossSignal();
  }

  void _closeDropdowns() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      final details = element.closest('details');
      if (details != null) {
        details.removeAttribute('open');
      }
    }
  }

  void _changeEntry(int entry) {
    profitLossEntriesSignal.value = entry;
    profitLossPageSignal.value = 1;
    refreshProfitLossSignal();
    _closeDropdowns();
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshProfitLossSignal();
      });
    }
    final entries = profitLossEntriesSignal.value;
    final reportState = profitLossSignal.value;
    final currentPage = profitLossPageSignal.value;
    final totalPages = reportState.value?.totalPages ?? 1;
    final totalItems = reportState.value?.totalItems ?? 0;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        div(
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
                          dropdownButton(
                            name: '10',
                            isSelected: entries == 10,
                            onClick: () => _changeEntry(10),
                          ),
                          dropdownButton(
                            name: '25',
                            isSelected: entries == 25,
                            onClick: () => _changeEntry(25),
                          ),
                          dropdownButton(
                            name: '50',
                            isSelected: entries == 50,
                            onClick: () => _changeEntry(50),
                          ),
                          dropdownButton(
                            name: '100',
                            isSelected: entries == 100,
                            onClick: () => _changeEntry(100),
                          ),
                        ],
                      ),
                    ]),
                    if (totalItems > 0)
                      .text(
                        'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, totalItems)} of $totalItems',
                      ),
                  ],
                ),
                DateRangePicker(
                  fromDate: reportsFromDateSignal.value,
                  toDate: reportsToDateSignal.value,
                  onChanged: (from, to) {
                    reportsFromDateSignal.value = from;
                    reportsToDateSignal.value = to;
                    profitLossPageSignal.value = 1;
                    refreshProfitLossSignal();
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
              classes:
                  'flex justify-between gap-2 items-center w-full sm:w-auto',
              [
                Searchbar(
                  placeholder: 'Search Products...',
                  classes: 'flex-1 sm:flex-none sm:w-64',
                  onInput: (val) {
                    profitLossSearchSignal.value = val;
                    profitLossPageSignal.value = 1;
                    refreshProfitLossSignal();
                  },
                ),
              ],
            ),
          ],
        ),

        if (showReportsStatsSignal.value &&
            reportState.hasValue &&
            reportState.value!.items.isNotEmpty)
          ProfitLossSummaryCards(
            totalCostPrice: reportState.value!.totalCostPrice,
            totalCollectedPrice: reportState.value!.totalCollectedPrice,
            totalProfit: reportState.value!.totalProfit,
            totalMarginPercentage: reportState.value!.totalMarginPercentage,
          ),

        if (storesSignal.value.isLoading || reportState.isLoading)
          Loading(text: 'Loading profit & loss report...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to view reports.')
        else if (reportState.hasError)
          CenteredMessage(
            message: reportState.error is ApiException
                ? (reportState.error as ApiException).message
                : 'Failed to load profit & loss report. Please try again.',
          )
        else if (reportState.hasValue && reportState.value!.items.isEmpty)
          CenteredMessage(message: 'No Profit & Loss data found.')
        else
          ProfitLossTableView(
            items: reportState.value?.items ?? [],
            sortState: _sortState,
            onSort: _onSort,
          ),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            profitLossPageSignal.value = page;
            refreshProfitLossSignal();
          },
        ),
      ],
    );
  }

  li dropdownButton({
    required String name,
    required bool isSelected,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes:
            'rounded-md text-xs hover:bg-neutral ${isSelected ? 'bg-neutral font-bold text-primary' : ''}',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
