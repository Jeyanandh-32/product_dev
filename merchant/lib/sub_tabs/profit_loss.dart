import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/profit_loss_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

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
    final currentPage = reportState.value?.currentPage ?? 1;
    final totalPages = reportState.value?.totalPages ?? 1;

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
                    if ((reportState.value?.totalItems ?? 0) > 0)
                      .text(
                        'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, reportState.value?.totalItems ?? 0)} of ${reportState.value?.totalItems ?? 0}',
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

                _buildStatsToggleButton(),
              ],
            ),
            div(
              classes:
                  'flex justify-between gap-2 items-center w-full sm:w-auto',
              [
                Searchbar(
                  placeholder: 'Search Product...',
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
          div(
            classes:
                'grid grid-cols-2 lg:grid-cols-4 gap-3 p-4 border-b border-border-medium bg-neutral/20',

            [
              summaryCard(
                title: 'Total Cost Price (COGS)',
                value:
                    '₹${reportState.value!.totalCostPrice.toStringAsFixed(2)}',
                textColor: 'text-gray-900',
              ),
              summaryCard(
                title: 'Total Net Revenue',
                value:
                    '₹${reportState.value!.totalCollectedPrice.toStringAsFixed(2)}',
                textColor: 'text-gray-900',
              ),
              summaryCard(
                title: 'Net Profit / Loss',
                value: '₹${reportState.value!.totalProfit.toStringAsFixed(2)}',
                textColor: reportState.value!.totalProfit >= 0
                    ? 'text-emerald-600'
                    : 'text-rose-600',
              ),
              summaryCard(
                title: 'Overall Margin',
                value:
                    '${reportState.value!.totalMarginPercentage.toStringAsFixed(2)}%',
                textColor: reportState.value!.totalMarginPercentage >= 0
                    ? 'text-emerald-600'
                    : 'text-rose-600',
              ),
            ],
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
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final item
                      in sortItems<ProfitLossItem, ProfitLossSortKey>(
                        items: reportState.value?.items ?? [],
                        sortState: _sortState,
                        getSortValue: (item, k) => switch (k) {
                          ProfitLossSortKey.name =>
                            item.productName.toLowerCase(),
                          ProfitLossSortKey.category =>
                            item.categoryName.toLowerCase(),
                          ProfitLossSortKey.counter =>
                            item.counterName.toLowerCase(),
                          ProfitLossSortKey.soldQuantity => item.soldQuantity,
                          ProfitLossSortKey.costPrice => item.costPrice,
                          ProfitLossSortKey.collectedPrice =>
                            item.collectedPrice,
                          ProfitLossSortKey.profit => item.profit,
                          ProfitLossSortKey.percentage =>
                            item.profitLossPercentage,
                        },
                      ))
                    tableRow(
                      name: item.productName,
                      category: item.categoryName,
                      counter: item.counterName,
                      soldQuantity: item.soldQuantity,
                      costPrice: item.costPrice,
                      collectedPrice: item.collectedPrice,
                      profit: item.profit,
                      percentage: item.profitLossPercentage,
                    ),
                ]),
              ],
            ),
          ]),

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

  div summaryCard({
    required String title,
    required String value,
    required String textColor,
  }) {
    return div(
      classes:
          'flex flex-col gap-1 p-3.5 bg-white rounded-xl border border-border-medium shadow-2xs',
      [
        span(classes: 'text-xs text-gray-500 font-medium', [.text(title)]),
        span(classes: 'text-lg font-bold $textColor', [.text(value)]),
      ],
    );
  }

  thead tableHead() {
    return thead([
      tr([
        th([]),
        SortableHeader<ProfitLossSortKey>(
          title: 'Name',
          sortKey: ProfitLossSortKey.name,
          currentSort: _sortState,
          onSort: _onSort,
          isTh: true,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Category',
          sortKey: ProfitLossSortKey.category,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Counter',
          sortKey: ProfitLossSortKey.counter,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Sold Quantity',
          sortKey: ProfitLossSortKey.soldQuantity,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Cost Price(₹)',
          sortKey: ProfitLossSortKey.costPrice,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Collected Price(₹)',
          sortKey: ProfitLossSortKey.collectedPrice,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Profit(₹)',
          sortKey: ProfitLossSortKey.profit,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<ProfitLossSortKey>(
          title: 'Profit/Loss(%)',
          sortKey: ProfitLossSortKey.percentage,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        th([]),
      ]),
    ]);
  }

  tr tableRow({
    required String name,
    required String category,
    required String counter,
    required int soldQuantity,
    required double costPrice,
    required double collectedPrice,
    required double profit,
    required double percentage,
  }) {
    final isProfit = profit >= 0;

    return tr([
      th([]),
      th(classes: 'whitespace-nowrap font-semibold text-black no-underline', [
        .text(name),
      ]),
      td(classes: 'whitespace-nowrap', [.text(category)]),
      td(classes: 'whitespace-nowrap', [.text(counter)]),
      td([.text('$soldQuantity')]),
      td([.text(costPrice.toStringAsFixed(2))]),
      td([.text(collectedPrice.toStringAsFixed(2))]),
      td([.text(profit.toStringAsFixed(2))]),
      td([
        div(
          classes:
              '${isProfit ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text('${percentage.toStringAsFixed(2)}%'),
          ],
        ),
      ]),
      th([]),
    ]);
  }

  Component _buildStatsToggleButton() {
    final showStats = showReportsStatsSignal.value;
    final activeClass = showStats
        ? 'border-primary bg-primary text-primary-content'
        : 'border-border-medium bg-white hover:bg-neutral text-gray-700';

    return button(
      type: .button,
      classes:
          'btn btn-sm rounded-full border text-xs font-semibold px-3 h-8 flex items-center gap-1.5 shadow-2xs cursor-pointer transition-all $activeClass',
      events: {
        'click': (e) {
          showReportsStatsSignal.value = !showStats;
        },
      },
      [
        if (showStats)
          EyeOff(classes: 'w-3.5 h-3.5')
        else
          ChartColumn(classes: 'w-3.5 h-3.5'),
        .text(showStats ? 'Hide Stats' : 'View Stats'),
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
