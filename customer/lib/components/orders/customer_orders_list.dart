import 'package:customer/components/orders/customer_order_tab.dart';
import 'package:customer/components/orders/order_tile.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';

/// Grid displaying customer order tiles or an empty state when none match.
class CustomerOrdersList extends StatelessComponent {
  final List<Order> orders;
  final CustomerOrderTab selectedTab;
  final ValueChanged<Order> onShowQr;

  const CustomerOrdersList({
    super.key,
    required this.orders,
    required this.selectedTab,
    required this.onShowQr,
  });

  @override
  Component build(BuildContext context) {
    final filteredOrders = orders.where((order) {
      if (selectedTab == CustomerOrderTab.pending) {
        return order.status == OrderStatus.pending ||
            order.status == OrderStatus.preparing;
      } else {
        return order.status == OrderStatus.completed ||
            order.status == OrderStatus.cancelled;
      }
    }).toList();

    if (filteredOrders.isEmpty) {
      final emptyMsg = selectedTab == CustomerOrderTab.pending
          ? 'No active orders waiting for pickup or preparation.'
          : 'No past orders recorded for this date.';

      return div(
        classes:
            'flex-1 min-h-[35vh] flex flex-col items-center justify-center p-8 text-center bg-gray-50/60 rounded-3xl border border-dashed border-gray-200 gap-3',
        [
          div(
            classes:
                'w-12 h-12 rounded-full bg-gray-100 flex items-center justify-center text-gray-400 mb-1',
            [
              ShoppingBag(classes: 'w-6 h-6'),
            ],
          ),
          h3(classes: 'text-sm font-bold text-gray-900', [
            .text('No ${selectedTab.name.toUpperCase()} orders'),
          ]),
          p(classes: 'text-xs text-gray-400 max-w-sm', [
            .text(emptyMsg),
          ]),
          button(
            classes:
                'mt-2 px-5 py-2.5 rounded-full bg-black text-white text-xs font-bold hover:bg-gray-800 transition-all cursor-pointer shadow-sm',
            onClick: () => Router.of(context).push('/'),
            [
              .text('Explore Stores'),
            ],
          ),
        ],
      );
    }

    return div(classes: 'grid grid-cols-1 lg:grid-cols-2 gap-4', [
      for (final order in filteredOrders)
        OrderTile(
          order: order,
          onShowQr: () => onShowQr(order),
        ),
    ]);
  }
}
