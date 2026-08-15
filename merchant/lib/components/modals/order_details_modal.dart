import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/components/modals/order_items_table_view.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Modal dialog presenting itemized receipt and order breakdown.
class OrderDetailsModal extends StatelessComponent {
  final AsyncState<Order?> state;

  const OrderDetailsModal({super.key, required this.state});

  String _formatAmount(double amount) {
    if (amount % 1 == 0) {
      return '${amount.toInt()}';
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: 'Orders Details',
      maxWidthClass: 'max-w-xl',
      child: () {
        if (state.isLoading) {
          return const Loading(
            text: 'Loading order details...',
            fullScreen: false,
          );
        }
        if (state.hasError) {
          return const CenteredMessage(
            message: 'Failed to load order details.',
          );
        }
        final order = state.value;
        if (order == null) {
          return const CenteredMessage(message: 'Order details not found.');
        }

        final totalQuantity = order.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );

        return div(classes: 'flex flex-col gap-6 pt-2 pb-1', [
          OrderItemsTableView(
            items: order.items,
            formatAmount: _formatAmount,
          ),

          div(classes: 'border-t border-gray-200/60 w-full', []),

          div(classes: 'flex flex-col gap-3 px-1 text-sm text-gray-800', [
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [
                .text('Total No Of Items'),
              ]),
              span(classes: 'font-medium text-gray-900', [
                .text('${order.items.length}'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [
                .text('Total Order Quantity'),
              ]),
              span(classes: 'font-medium text-gray-900', [
                .text('$totalQuantity'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [.text('Sub Total')]),
              span(classes: 'font-medium text-gray-900', [
                .text('Rs. ${_formatAmount(order.subtotal)}'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [
                .text('Total Discount'),
              ]),
              span(classes: 'font-medium text-gray-900', [
                .text('Rs. ${_formatAmount(order.discountTotal)}'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [.text('Total Tax')]),
              span(classes: 'font-medium text-gray-900', [
                .text('Rs. ${_formatAmount(order.taxTotal)}'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [.text('Ordering Channel')]),
              span(classes: 'font-semibold text-gray-900 uppercase', [
                .text(order.source.name == 'web' ? 'Online (Customer App)' : 'POS Terminal'),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [.text('Order Type')]),
              span(classes: 'font-semibold text-gray-900 uppercase', [
                .text(order.type.name),
              ]),
            ]),
            div(classes: 'flex justify-between items-center', [
              span(classes: 'font-normal text-gray-800', [.text('Payment Mode')]),
              span(classes: 'font-semibold text-gray-900 uppercase', [
                .text(order.paymentMethod.name),
              ]),
            ]),
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
                  .text('Rs. ${_formatAmount(order.walletDeduction.toDouble())}'),
                ]),
              ]),
            div(
              classes:
                  'flex justify-between items-center text-base font-bold text-gray-900 pt-2 border-t border-gray-100',
              [
                span([.text('Grand Total')]),
                span([.text('Rs. ${_formatAmount(order.grandTotal)}')]),
              ],
            ),
          ]),
        ]);
      }(),
    );
  }
}
