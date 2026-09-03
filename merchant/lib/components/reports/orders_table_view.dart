import 'package:date_format/date_format.dart' as df;
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/reports/order_table_row.dart';
import 'package:merchant/components/reports/orders_table_header.dart';
import 'package:merchant/components/sortable_header.dart';
import 'package:merchant/signals/orders_signal.dart';
import 'package:merchant/utils/payment_formatter.dart';
import 'package:models/models.dart';

/// Scrollable orders table view with column sorting and row interactions.
class OrdersTableView extends StatelessComponent {
  final List<Order> orders;
  final SortState<OrderSortKey> sortState;
  final ValueChanged<OrderSortKey> onSort;

  const OrdersTableView({
    super.key,
    required this.orders,
    required this.sortState,
    required this.onSort,
  });

  String _formatDate(DateTime dt) =>
      df.formatDate(dt.toLocal(), [df.dd, '/', df.mm, '/', df.yyyy]);

  String _formatOrderStatus(OrderStatus status) {
    return switch (status) {
      OrderStatus.completed => 'COMPLETED',
      OrderStatus.pending => 'PENDING',
      OrderStatus.cancelled => 'CANCELLED',
      OrderStatus.preparing => 'PREPARING',
    };
  }

  @override
  Component build(BuildContext context) {
    final sortedOrders = sortItems<Order, OrderSortKey>(
      items: orders,
      sortState: sortState,
      getSortValue: (item, k) => switch (k) {
        .orderReference => item.orderReference.toLowerCase(),
        .date => item.createdAt,
        .orderId => '${item.billNo}',
        .grossAmount => item.subtotal,
        .discountAmount => item.discountTotal,
        .platformFee => item.platformFee,
        .gatewayCharges => item.gatewayCharges,
        .walletPaid => item.walletDeduction,
        .netAmount => item.grandTotal,
        .paymentMode => item.paymentMethod.name.toLowerCase(),
        .paymentStatus => item.paymentStatus.name.toLowerCase(),
        .orderStatus => item.status.name.toLowerCase(),
      },
    );

    return div(classes: 'flex-1 min-h-0 overflow-auto', [
      table(
        classes: 'table table-zebra table-pin-rows table-pin-cols',
        [
          OrdersTableHeader(
            sortState: sortState,
            onSort: onSort,
          ),
          tbody([
            for (final order in sortedOrders)
              OrderTableRow(
                orderReference: order.orderReference,
                date: _formatDate(order.createdAt),
                orderId: '${order.billNo}',
                grossAmount: order.subtotal.toDouble(),
                discountAmount: order.discountTotal.toDouble(),
                platformFee: order.platformFee,
                gatewayCharges: order.gatewayCharges,
                walletAmount: order.walletDeduction.toDouble(),
                netAmount: order.grandTotal.toDouble(),
                paymentType: PaymentFormatter.formatPaymentType(
                  order.paymentMethod,
                ),
                paymentStatus: order.paymentStatus,
                status: _formatOrderStatus(order.status),
                onClick: () {
                  fetchOrderDetails(order.id);
                },
              ),
          ]),
        ],
      ),
    ]);
  }
}
