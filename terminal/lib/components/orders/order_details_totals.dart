import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/cart/cart_summary_item_row.dart';
import 'package:terminal/components/orders/order_details_totals_header.dart';

/// Totals and price summary with previous details inline and extra metrics in popup.
class OrderDetailsTotals extends StatelessWidget {
  final Order order;

  const OrderDetailsTotals({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final originalTotal = order.subtotal - order.discountTotal + order.taxTotal;
    final totalPaid = order.walletDeduction + order.grandTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        OrderDetailsTotalsHeader(order: order),
        const Gap(10),
        CartSummaryItemRow(
          title: 'Subtotal',
          value: '₹${order.subtotal.toStringAsFixed(2)}',
        ),
        const Gap(8),
        if (order.discountTotal > 0) ...[
          CartSummaryItemRow(
            title: 'Discount',
            value: '-₹${order.discountTotal.toStringAsFixed(2)}',
            valueColor: const Color(0xFF15803D),
          ),
          const Gap(8),
        ],
        CartSummaryItemRow(
          title: 'Taxes',
          value: '₹${order.taxTotal.toStringAsFixed(2)}',
        ),
        const Gap(8),
        const FDivider(),
        const Gap(8),
        if (order.walletDeduction > 0) ...[
          CartSummaryItemRow(
            title: 'Order Total',
            value: '₹${originalTotal.toStringAsFixed(2)}',
          ),
          const Gap(8),
          CartSummaryItemRow(
            title: 'Wallet Paid',
            value: '₹${order.walletDeduction.toStringAsFixed(2)}',
            valueColor: const Color(0xFF15803D),
          ),
          const Gap(8),
          CartSummaryItemRow(
            title: '${order.paymentMethod.name.toUpperCase()} Paid',
            value: '₹${order.grandTotal.toStringAsFixed(2)}',
          ),
          const Gap(8),
          const FDivider(),
          const Gap(8),
          CartSummaryItemRow(
            title: 'Total Paid',
            value: '₹${totalPaid.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ] else ...[
          CartSummaryItemRow(
            title: 'Grand Total',
            value: '₹${order.grandTotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ],
    );
  }
}
