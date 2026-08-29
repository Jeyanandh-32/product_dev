import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/orders/order_qr_modal.dart';
import 'package:customer/components/orders/order_status_card.dart';
import 'package:customer/components/orders/order_status_pending_card.dart';
import 'package:customer/components/signal_component.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Screen presenting the verified status of a placed customer order.
class OrderStatusPage extends SignalComponent {
  const OrderStatusPage({required this.reference, super.key});

  final String reference;

  @override
  SignalState<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends SignalState<OrderStatusPage> {
  Order? _order;
  String? _storeSlug;
  bool _isLoading = true;
  String? _errorMessage;
  bool _showQrModal = false;

  @override
  void initState() {
    super.initState();
    _fetchOrderStatus();
  }

  Future<void> _fetchOrderStatus() async {
    try {
      final order = await OrderRepository.verifyStatus(
        reference: component.reference,
      );

      String? slug;
      try {
        final stores = await StoreRepository.getOnlineStores();
        final matchedStore = stores
            .where((store) => store.id == order.storeId)
            .firstOrNull;
        slug = matchedStore?.slug;
      } catch (_) {}

      setState(() {
        _order = order;
        _storeSlug = slug;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onShowQr(Order order) {
    setState(() => _showQrModal = true);
  }

  void _onBackNavigation() {
    if (web.window.history.length > 1) {
      web.window.history.back();
    } else if (_storeSlug != null && _storeSlug!.isNotEmpty) {
      Router.of(context).push('/store/$_storeSlug');
    } else {
      Router.of(context).push('/orders');
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    if (_isLoading) {
      return div(
        classes: 'flex-1 min-h-[50vh] flex flex-col items-center justify-center gap-4 text-center my-auto w-full',
        [
          span(classes: 'loading loading-spinner loading-lg text-black', []),
          p(classes: 'text-sm font-semibold text-gray-500', [
            .text('Loading order details...'),
          ]),
        ],
      );
    }

    final order = _order;
    if (_errorMessage != null || order == null) {
      return OrderStatusPendingCard(reference: component.reference);
    }

    return div(
      classes: 'max-w-3xl mx-auto w-full py-8 px-4 flex flex-col gap-6',
      [
        div(classes: 'flex items-center gap-3', [
          button(
            classes: 'w-9 h-9 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95 shrink-0',
            onClick: _onBackNavigation,
            [ArrowLeft(classes: 'w-5 h-5')],
          ),
          h1(
            classes:
                'text-xl sm:text-2xl font-extrabold text-black tracking-tight',
            [
              .text('Order Details'),
            ],
          ),
        ]),

        OrderStatusCard(
          order: order,
          storeSlug: _storeSlug,
          onShowQr: () => _onShowQr(order),
          onBackToMenu: () {
            if (_storeSlug != null && _storeSlug!.isNotEmpty) {
              Router.of(context).push('/store/$_storeSlug');
            } else {
              Router.of(context).push('/');
            }
          },
        ),

        if (_showQrModal)
          OrderQrModal(
            orderReference: order.orderReference,
            billNo: order.billNo,
            onClose: () => setState(() => _showQrModal = false),
          ),
      ],
    );
  }
}
