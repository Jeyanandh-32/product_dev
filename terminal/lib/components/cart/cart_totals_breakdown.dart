import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/cart/cart_discount_field.dart';
import 'package:terminal/components/cart/cart_payment_mode_selector.dart';
import 'package:terminal/components/cart/cart_print_bill_toggle.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Clean totals breakdown with high-contrast, clear typography.
class CartTotalsBreakdown extends StatelessWidget {
  final CartState cart;
  final PaymentMethod paymentMode;
  final TextEditingController discountController;

  const CartTotalsBreakdown({
    super.key,
    required this.cart,
    required this.paymentMode,
    required this.discountController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText(
          'Order Summary',
          style: TextStyler()
              .fontSize(16)
              .fontWeight(.w800)
              .color(const Color(0xFF0F172A)),
        ),
        const Gap(14),
        _summaryRow(title: 'Total No of Items', value: '${cart.noOfItems}'),
        const Gap(8),
        _summaryRow(
          title: 'Total Order Quantity',
          value: '${cart.orderQuantity}',
        ),
        const Gap(8),
        _summaryRow(
          title: 'Subtotal',
          value: '₹${cart.subtotal.toStringAsFixed(2)}',
        ),
        const Gap(8),
        if (paymentMode != PaymentMethod.complimentary) ...[
          CartDiscountField(controller: discountController),
          const Gap(8),
        ],
        if (cart.discountTotal > 0) ...[
          _summaryRow(
            title: 'Total Discount',
            value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
            valueColor: const Color(0xFF16A34A),
          ),
          const Gap(8),
        ],
        _summaryRow(
          title: 'Taxes',
          value: '₹${cart.taxTotal.toStringAsFixed(2)}',
        ),
        const Gap(12),
        CartPaymentModeSelector(selectedMode: paymentMode),
        const Gap(12),
        const CartPrintBillToggle(),
        const Gap(12),
        const FDivider(),
        const Gap(12),
        _summaryRow(
          title: 'Grand Total',
          value: '₹${cart.grandTotal.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StyledText(
          title,
          style: TextStyler()
              .fontSize(isTotal ? 16 : 13.5)
              .fontWeight(isTotal ? .w800 : .w600)
              .color(isTotal ? const Color(0xFF000000) : const Color(0xFF334155)),
        ),
        StyledText(
          value,
          style: TextStyler()
              .fontSize(isTotal ? 18 : 14)
              .fontWeight(isTotal ? .w900 : .w700)
              .color(valueColor ?? const Color(0xFF0F172A)),
        ),
      ],
    );
  }
}
