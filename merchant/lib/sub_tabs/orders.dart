import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/order_details_modal.dart';
import 'package:merchant/components/reports/order_summary_cards.dart';
import 'package:merchant/components/reports/orders_filter_bar.dart';
import 'package:merchant/components/reports/orders_table_header.dart';
import 'package:merchant/components/reports/orders_table_view.dart';
import 'package:merchant/components/reports/stats_toggle_button.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/orders_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:web/web.dart' as web;

/// Orders management sub-tab displaying order listings, filters, summary cards, and pagination.
class Orders extends SignalComponent {
  const Orders({super.key});

  @override
  SignalState<Orders> createState() => _OrdersState();
}

class _OrdersState extends SignalState<Orders> {
  String? _loadedStoreId;
  SortState<OrderSortKey> _sortState = const SortState<OrderSortKey>();

  void _onSort(OrderSortKey key) {
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
    refreshOrdersSignal();
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
    entriesSignal.value = entry;
    ordersPageSignal.value = 1;
    refreshOrdersSignal();
    _closeDropdowns();
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    if (store != null && _loadedStoreId != store.id) {
      _loadedStoreId = store.id;
      Future.microtask(() {
        refreshOrdersSignal();
      });
    }
    final entries = entriesSignal.value;
    final orders = ordersSignal.value;
    final currentPage = ordersPageSignal.value;
    final totalPages = ordersTotalPagesSignal.value;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModalSignal.value == ActiveModal.orderDetails)
          OrderDetailsModal(state: selectedOrderSignal.value),

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
                    if (ordersTotalSignal.value > 0)
                      .text(
                        'Showing ${((currentPage - 1) * entries) + 1}–${(currentPage * entries).clamp(0, ordersTotalSignal.value)} of ${ordersTotalSignal.value}',
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
              classes:
                  'flex justify-between gap-2 items-center w-full sm:w-auto',
              [
                Searchbar(
                  placeholder: 'Search Orders...',
                  classes: 'flex-1 sm:flex-none sm:w-64',
                  onInput: (val) {
                    ordersSearchSignal.value = val;
                    ordersPageSignal.value = 1;
                    refreshOrdersSignal();
                  },
                ),
              ],
            ),
          ],
        ),

        if (showReportsStatsSignal.value &&
            orders.hasValue &&
            orders.value!.isNotEmpty)
          OrderSummaryCards(
            totalOrders: ordersSummarySignal.value.totalOrders,
            grossSubtotal: ordersSummarySignal.value.grossSubtotal,
            totalDiscount: ordersSummarySignal.value.totalDiscount,
            netRevenue: ordersSummarySignal.value.netRevenue,
            cashCollected: ordersSummarySignal.value.cashCollected,
            upiCollected: ordersSummarySignal.value.upiCollected,
            walletCollected: ordersSummarySignal.value.walletCollected,
            freeTotal: ordersSummarySignal.value.freeTotal,
          ),

        if (storesSignal.value.isLoading || orders.isLoading)
          Loading(text: 'Loading orders...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to view orders.')
        else if (orders.hasError)
          CenteredMessage(
            message: orders.error is ApiException
                ? (orders.error as ApiException).message
                : 'Failed to load orders. Please try again.',
          )
        else if (orders.hasValue && orders.value!.isEmpty)
          CenteredMessage(message: 'No Orders found.')
        else
          OrdersTableView(
            orders: orders.value ?? [],
            sortState: _sortState,
            onSort: _onSort,
          ),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            ordersPageSignal.value = page;
            refreshOrdersSignal();
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
