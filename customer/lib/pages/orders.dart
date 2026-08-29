import 'package:api_client/api_client.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/orders/customer_order_status_tabs.dart';
import 'package:customer/components/orders/customer_orders_header.dart';
import 'package:customer/components/orders/customer_orders_list.dart';
import 'package:customer/components/orders/order_qr_modal.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Customer orders screen showing active and past order history with dynamic QR codes.
class CustomerOrdersPage extends SignalComponent {
  const CustomerOrdersPage({super.key});

  @override
  SignalState<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
}

class _CustomerOrdersPageState extends SignalState<CustomerOrdersPage> {
  late final _ordersSignal = asyncSignal<PaginatedResponse<Order>>(
    const AsyncLoading(),
  );

  String _selectedDate = '';
  String _selectedTab = 'pending';
  Order? _qrModalOrder;

  @override
  void initState() {
    super.initState();
    _selectedDate = _formatDate(DateTime.now());
    _fetchOrders();
  }

  String _formatDate(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _fetchOrders() async {
    _ordersSignal.value = const AsyncLoading();
    try {
      final activeStoreId = currentCartStoreIdSignal.value;
      final res = await OrderRepository.getCustomerOrders(
        storeId: activeStoreId,
        date: _selectedDate,
        page: 1,
        size: 50,
      );
      _ordersSignal.value = AsyncData(res);
    } catch (e, st) {
      _ordersSignal.value = AsyncError(e, st);
    }
  }

  void _onShowQr(Order order) {
    setState(() => _qrModalOrder = order);
  }

  @override
  Component buildSignal(BuildContext context) {
    final ordersState = _ordersSignal.value;

    return div(
      classes:
          'flex flex-col gap-6 w-full max-w-4xl mx-auto py-2 flex-1 min-h-0',
      [
        CustomerOrdersHeader(
          selectedDate: _selectedDate,
          onDateChanged: (val) {
            setState(() => _selectedDate = val);
            _fetchOrders();
          },
        ),

        CustomerOrderStatusTabs(
          selectedTab: _selectedTab,
          onTabSelected: (val) => setState(() => _selectedTab = val),
        ),

        switch (ordersState) {
          AsyncData(value: final paginated) => CustomerOrdersList(
            orders: paginated.items,
            selectedTab: _selectedTab,
            onShowQr: _onShowQr,
          ),
          AsyncError() => div(
            classes: 'flex-1 min-h-[30vh] bg-red-50 text-red-600 rounded-2xl text-center font-semibold border border-red-100 text-xs flex flex-col items-center justify-center gap-2 p-6',
            [
              .text('Failed to load your orders.'),
              button(
                classes: 'btn btn-xs bg-red-600 text-white border-0',
                onClick: _fetchOrders,
                [.text('Retry')],
              ),
            ],
          ),
          _ => div(
            classes: 'flex-1 min-h-[40vh] flex flex-col items-center justify-center gap-3 text-center my-auto',
            [
              span(
                classes: 'loading loading-spinner loading-lg text-black',
                [],
              ),
              p(classes: 'text-xs font-semibold text-gray-400', [
                .text('Loading orders...'),
              ]),
            ],
          ),
        },

        if (_qrModalOrder case final qrOrder?)
          OrderQrModal(
            orderReference: qrOrder.orderReference,
            billNo: qrOrder.billNo,
            onClose: () => setState(() => _qrModalOrder = null),
          ),
      ],
    );
  }
}
