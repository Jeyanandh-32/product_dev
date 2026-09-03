import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Renders the key-value attributes and pricing breakdown inside the order details modal.
class OrderDetailsSummarySection extends StatelessComponent {
  final Order order;
  final String Function(double) formatAmount;

  const OrderDetailsSummarySection({
    super.key,
    required this.order,
    required this.formatAmount,
  });

  @override
  Component build(BuildContext context) {
    final totalQuantity = order.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return div(classes: 'flex flex-col gap-3 px-1 text-sm text-gray-800', [
      _row('Total No Of Items', '${order.items.length}'),
      _row('Total Order Quantity', '$totalQuantity'),
      _row('Sub Total', 'Rs. ${formatAmount(order.subtotal)}'),
      _row('Total Discount', 'Rs. ${formatAmount(order.discountTotal)}'),
      _row('Total Tax', 'Rs. ${formatAmount(order.taxTotal)}'),
      if (order.platformFee > 0)
        div(classes: 'flex justify-between items-center text-gray-600', [
          span(classes: 'font-normal', [
            .text('Platform Fee (1.99% - Paid by Customer)'),
          ]),
          span(classes: 'font-medium text-gray-900', [
            .text('Rs. ${formatAmount(order.platformFee)}'),
          ]),
        ]),
      if (order.gatewayCharges > 0)
        div(classes: 'flex justify-between items-center text-gray-600', [
          span(classes: 'font-normal', [
            .text('Gateway Charges (Paid by Customer)'),
          ]),
          span(classes: 'font-medium text-gray-900', [
            .text('Rs. ${formatAmount(order.gatewayCharges)}'),
          ]),
        ]),
      _row(
        'Ordering Channel',
        order.source.name == 'web' ? 'Online (Customer App)' : 'POS Terminal',
        isUpper: true,
      ),
      _row('Order Type', order.type.name, isUpper: true),
      _row('Payment Mode', order.paymentMethod.name, isUpper: true),
      div(classes: 'flex justify-between items-center', [
        span(classes: 'font-normal text-gray-800', [.text('Payment Status')]),
        span(classes: 'font-semibold text-emerald-600 uppercase', [
          .text(order.paymentStatus.name),
        ]),
      ]),
      if (order.walletDeduction > 0)
        div(classes: 'flex justify-between items-center text-amber-700', [
          span(classes: 'font-normal', [.text('Customer Wallet Paid')]),
          span(classes: 'font-medium', [
            .text('Rs. ${formatAmount(order.walletDeduction.toDouble())}'),
          ]),
        ]),
      div(
        classes: 'flex justify-between items-center text-base font-bold text-gray-900 pt-2 border-t border-gray-100',
        [
          span([.text('Grand Total')]),
          span([.text('Rs. ${formatAmount(order.grandTotal)}')]),
        ],
      ),
    ]);
  }

  Component _row(String label, String value, {bool isUpper = false}) {
    return div(classes: 'flex justify-between items-center', [
      span(classes: 'font-normal text-gray-800', [.text(label)]),
      span(
        classes:
            'font-medium text-gray-900 ${isUpper ? 'uppercase font-semibold' : ''}',
        [.text(value)],
      ),
    ]);
  }
}
