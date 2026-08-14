import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/date_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stock_summary_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

enum StockSummarySortKey {
  name,
  openingStock,
  inQty,
  outQty,
  wastageQty,
  adjustmentQty,
  closingStock,
}

class StockSummary extends SignalComponent {
  const StockSummary({super.key});

  @override
  SignalState<StockSummary> createState() => _StockSummaryState();
}

class _StockSummaryState extends SignalState<StockSummary> {
  String? _loadedStoreId;
  SortState<StockSummarySortKey> _sortState =
      const SortState<StockSummarySortKey>();

  void _onSort(StockSummarySortKey key) {
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
    refreshStockSummarySignal();
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
    stockSummaryEntriesSignal.value = entry;
    stockSummaryPageSignal.value = 1;
    refreshStockSummarySignal();
    _closeDropdowns();
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshStockSummarySignal();
      });
    }
    final entries = stockSummaryEntriesSignal.value;

    final reportState = stockSummarySignal.value;
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
                DatePicker(
                  date: stockSummaryDateSignal.value,

                  onDateChanged: (val) {
                    stockSummaryDateSignal.value = val;
                    stockSummaryPageSignal.value = 1;
                    refreshStockSummarySignal();
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
                    stockSummarySearchSignal.value = val;
                    stockSummaryPageSignal.value = 1;
                    refreshStockSummarySignal();
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
                title: 'Restocked (In)',
                value: '+${reportState.value!.totalIn}',
                textColor: 'text-emerald-600',
              ),
              summaryCard(
                title: 'Sold (Out)',
                value: '-${reportState.value!.totalOut}',
                textColor: 'text-rose-600',
              ),
              summaryCard(
                title: 'Wastage',
                value: '-${reportState.value!.totalWastage}',
                textColor: 'text-amber-600',
              ),
              summaryCard(
                title: 'Adjustment',
                value: reportState.value!.totalAdjustment > 0
                    ? '+${reportState.value!.totalAdjustment}'
                    : '${reportState.value!.totalAdjustment}',
                textColor: reportState.value!.totalAdjustment != 0
                    ? (reportState.value!.totalAdjustment > 0
                          ? 'text-emerald-600'
                          : 'text-rose-600')
                    : 'text-gray-700',
              ),
            ],
          ),

        if (storesSignal.value.isLoading || reportState.isLoading)
          Loading(text: 'Loading stock summary report...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to view reports.')
        else if (reportState.hasError)
          CenteredMessage(
            message: reportState.error is ApiException
                ? (reportState.error as ApiException).message
                : 'Failed to load stock summary report. Please try again.',
          )
        else if (reportState.hasValue && reportState.value!.items.isEmpty)
          CenteredMessage(message: 'No Stock Summary data found.')
        else
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final item
                      in sortItems<StockSummaryItem, StockSummarySortKey>(
                        items: reportState.value?.items ?? [],
                        sortState: _sortState,
                        getSortValue: (item, k) => switch (k) {
                          StockSummarySortKey.name =>
                            item.productName.toLowerCase(),
                          StockSummarySortKey.openingStock => item.openingStock,
                          StockSummarySortKey.inQty => item.inQuantity,
                          StockSummarySortKey.outQty => item.outQuantity,
                          StockSummarySortKey.wastageQty =>
                            item.wastageQuantity,
                          StockSummarySortKey.adjustmentQty =>
                            item.adjustmentQuantity,
                          StockSummarySortKey.closingStock => item.closingStock,
                        },
                      ))
                    tableRow(
                      name: item.productName,
                      openingStock: item.openingStock,
                      inQty: item.inQuantity,
                      outQty: item.outQuantity,
                      wastageQty: item.wastageQuantity,
                      adjustmentQty: item.adjustmentQuantity,
                      closingStock: item.closingStock,
                    ),
                ]),
              ],
            ),
          ]),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            stockSummaryPageSignal.value = page;
            refreshStockSummarySignal();
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
        SortableHeader<StockSummarySortKey>(
          title: 'Name',
          sortKey: StockSummarySortKey.name,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Opening Stock',
          sortKey: StockSummarySortKey.openingStock,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'In',
          sortKey: StockSummarySortKey.inQty,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Out',
          sortKey: StockSummarySortKey.outQty,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Wastage',
          sortKey: StockSummarySortKey.wastageQty,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Adjustment',
          sortKey: StockSummarySortKey.adjustmentQty,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        SortableHeader<StockSummarySortKey>(
          title: 'Closing Stock',
          sortKey: StockSummarySortKey.closingStock,
          currentSort: _sortState,
          onSort: _onSort,
        ),
        th([]),
      ]),
    ]);
  }

  tr tableRow({
    required String name,
    required int openingStock,
    required int inQty,
    required int outQty,
    required int wastageQty,
    required int adjustmentQty,
    required int closingStock,
  }) {
    final inText = inQty > 0 ? '+$inQty' : '0';
    final outText = outQty > 0 ? '-$outQty' : '0';
    final wastageText = wastageQty > 0 ? '-$wastageQty' : '0';

    String adjText;
    if (adjustmentQty > 0) {
      adjText = '+$adjustmentQty';
    } else if (adjustmentQty < 0) {
      adjText = '$adjustmentQty';
    } else {
      adjText = '0';
    }

    return tr([
      th([]),
      th(classes: 'whitespace-nowrap font-medium text-primary', [
        .text(name),
      ]),
      td([.text('$openingStock')]),
      td(
        classes: inQty > 0 ? 'font-semibold text-emerald-600' : 'text-gray-500',
        [.text(inText)],
      ),
      td(
        classes: outQty > 0 ? 'font-semibold text-rose-600' : 'text-gray-500',
        [.text(outText)],
      ),
      td(
        classes: wastageQty > 0
            ? 'font-semibold text-rose-600'
            : 'text-gray-500',
        [.text(wastageText)],
      ),
      td(
        classes: adjustmentQty != 0
            ? (adjustmentQty > 0
                  ? 'font-semibold text-emerald-600'
                  : 'font-semibold text-rose-600')
            : 'text-gray-500',
        [.text(adjText)],
      ),
      td(classes: 'text-gray-900', [.text('$closingStock')]),
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
