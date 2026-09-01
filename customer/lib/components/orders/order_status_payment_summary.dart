import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Renders the financial breakdown and payment status rows on the order status screen.
class OrderStatusPaymentSummary extends StatelessComponent {
  final Order order;
  final String paymentMethodLabel;
  final String statusTextClass;

  const OrderStatusPaymentSummary({
    super.key,
    required this.order,
    required this.paymentMethodLabel,
    required this.statusTextClass,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'w-full flex flex-col gap-2 text-sm', [
      div(classes: 'flex justify-between text-gray-500', [
        span([.text('Subtotal')]),
        span(classes: 'font-semibold text-black', [
          .text('₹${order.subtotal.toStringAsFixed(2)}'),
        ]),
      ]),
      if (order.discountTotal > 0)
        div(classes: 'flex justify-between text-gray-500', [
          span([.text('Discounts')]),
          span(classes: 'font-semibold text-rose-600', [
            .text('-₹${order.discountTotal.toStringAsFixed(2)}'),
          ]),
        ]),
      if (order.platformFee > 0)
        div(classes: 'flex justify-between text-gray-500', [
          span([.text('Platform Fee (1.99%)')]),
          span(classes: 'font-semibold text-black', [
            .text('₹${order.platformFee.toStringAsFixed(2)}'),
          ]),
        ]),
      if (order.taxTotal > 0)
        div(classes: 'flex justify-between text-gray-500', [
          span([.text('Total Tax')]),
          span(classes: 'font-semibold text-black', [
            .text('₹${order.taxTotal.toStringAsFixed(2)}'),
          ]),
        ]),
      if (order.walletDeduction > 0)
        div(classes: 'flex justify-between text-gray-500', [
          span([.text('Wallet / Reward Paid')]),
          span(classes: 'font-semibold text-emerald-600', [
            .text('-₹${order.walletDeduction.toStringAsFixed(2)}'),
          ]),
        ]),
      div(classes: 'flex justify-between text-gray-500', [
        span([.text('Payment Method')]),
        span(classes: 'font-semibold text-black', [
          .text(paymentMethodLabel),
        ]),
      ]),
      div(classes: 'flex justify-between text-gray-500', [
        span([.text('Payment Status')]),
        span(classes: statusTextClass, [
          .text(order.paymentStatus.name.toUpperCase()),
        ]),
      ]),
      div(
        classes: 'flex justify-between text-base font-extrabold text-black pt-2 border-t border-gray-100',
        [
          span([.text('Total Amount')]),
          span([.text('₹${order.grandTotal.toStringAsFixed(2)}')]),
        ],
      ),
    ]);
  }
}
