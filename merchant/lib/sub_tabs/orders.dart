import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/order_details_modal.dart';
import 'package:merchant/components/reports/order_summary_cards.dart';
import 'package:merchant/components/reports/orders_table_header.dart';
import 'package:merchant/components/reports/orders_table_view.dart';
import 'package:merchant/components/reports/orders_toolbar.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/orders_signal.dart';
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

        OrdersToolbar(
          entries: entries,
          currentPage: currentPage,
          totalCount: ordersTotalSignal.value,
          onEntryChanged: _changeEntry,
          onSearch: (val) {
            ordersSearchSignal.value = val;
            ordersPageSignal.value = 1;
            refreshOrdersSignal();
          },
        ),

        if (showReportsStatsSignal.value &&
            orders.hasValue &&
            orders.value!.isNotEmpty)
          OrderSummaryCards(
            totalOrders: ordersSummarySignal.value.totalOrders,
            grossSubtotal: ordersSummarySignal.value.grossSubtotal,
            totalDiscount: ordersSummarySignal.value.totalDiscount,
            netRevenue: ordersSummarySignal.value.netRevenue,
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
}
