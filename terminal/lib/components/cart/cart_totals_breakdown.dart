import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart_discount_field.dart';
import 'package:terminal/components/cart/cart_payment_mode_selector.dart';
import 'package:terminal/components/cart/cart_print_bill_toggle.dart';
import 'package:terminal/components/cart/cart_summary_item_row.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Clean totals breakdown with collapsible order item & tax metrics.
class CartTotalsBreakdown extends SignalWidget {
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
    final showDetails = showOrderSummaryDetailsSignal.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyledText(
              'Order Summary',
              style: TextStyler()
                  .fontSize(15)
                  .fontWeight(.w800)
                  .color(const Color(0xFF0F172A)),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PressableBox(
                onPress: () => CartController.toggleSummaryDetails(),
                style: BoxStyler()
                    .paddingX(8)
                    .paddingY(4)
                    .borderRadiusAll(const Radius.circular(8))
                    .color(const Color(0xFFF1F5F9))
                    .alignment(Alignment.center)
                    .onHovered(BoxStyler().color(const Color(0xFF000000))),
                child: Row(
                  children: [
                    StyledText(
                      showDetails ? 'Hide' : 'Details',
                      style: TextStyler()
                          .fontSize(11.5)
                          .fontWeight(.w700)
                          .color(const Color(0xFF475569))
                          .onHovered(
                            TextStyler().color(const Color(0xFFFFFFFF)),
                          ),
                    ),
                    const Gap(3),
                    StyledIcon(
                      icon: showDetails
                          ? FLucideIcons.chevronUp
                          : FLucideIcons.chevronDown,
                      style: IconStyler()
                          .size(13)
                          .color(const Color(0xFF475569))
                          .onHovered(
                            IconStyler().color(const Color(0xFFFFFFFF)),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showDetails) ...[
          const Gap(12),
          CartSummaryItemRow(
            title: 'Total No of Items',
            value: '${cart.noOfItems}',
          ),
          const Gap(8),
          CartSummaryItemRow(
            title: 'Total Order Quantity',
            value: '${cart.orderQuantity}',
          ),
          const Gap(8),
          CartSummaryItemRow(
            title: 'Subtotal',
            value: '₹${cart.subtotal.toStringAsFixed(2)}',
          ),
          const Gap(8),
          if (paymentMode != PaymentMethod.complimentary) ...[
            CartDiscountField(controller: discountController),
            const Gap(8),
          ],
          if (cart.discountTotal > 0) ...[
            CartSummaryItemRow(
              title: 'Total Discount',
              value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
              valueColor: const Color(0xFF16A34A),
            ),
            const Gap(8),
          ],
          CartSummaryItemRow(
            title: 'Taxes',
            value: '₹${cart.taxTotal.toStringAsFixed(2)}',
          ),
        ],
        const Gap(12),
        CartPaymentModeSelector(selectedMode: paymentMode),
        const Gap(12),
        const CartPrintBillToggle(),
        const Gap(12),
        const FDivider(),
        const Gap(12),
        CartSummaryItemRow(
          title: 'Grand Total',
          value: '₹${cart.grandTotal.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }
}
