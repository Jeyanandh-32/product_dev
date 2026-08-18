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

/// Clean totals breakdown with collapsible order item & tax metrics styled for senior readability.
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
                  .fontSize(17.5)
                  .fontWeight(.w900)
                  .color(const Color(0xFF000000)),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PressableBox(
                onPress: () => CartController.toggleSummaryDetails(),
                style: BoxStyler()
                    .paddingX(10)
                    .paddingY(5)
                    .borderRadiusAll(const Radius.circular(8))
                    .color(const Color(0xFFF1F5F9))
                    .alignment(Alignment.center)
                    .onHovered(BoxStyler().color(const Color(0xFF000000))),
                child: Row(
                  children: [
                    StyledText(
                      showDetails ? 'Hide' : 'Details',
                      style: TextStyler()
                          .fontSize(13)
                          .fontWeight(.w800)
                          .color(const Color(0xFF0F172A))
                          .onHovered(
                            TextStyler().color(const Color(0xFFFFFFFF)),
                          ),
                    ),
                    const Gap(4),
                    StyledIcon(
                      icon: showDetails
                          ? FLucideIcons.chevronUp
                          : FLucideIcons.chevronDown,
                      style: IconStyler()
                          .size(14)
                          .color(const Color(0xFF0F172A))
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
          const Gap(14),
          CartSummaryItemRow(
            title: 'Total No of Items',
            value: '${cart.noOfItems}',
          ),
          const Gap(10),
          CartSummaryItemRow(
            title: 'Total Order Quantity',
            value: '${cart.orderQuantity}',
          ),
          const Gap(10),
          CartSummaryItemRow(
            title: 'Subtotal',
            value: '₹${cart.subtotal.toStringAsFixed(2)}',
          ),
          const Gap(10),
          if (paymentMode != PaymentMethod.complimentary) ...[
            CartDiscountField(controller: discountController),
            const Gap(10),
          ],
          if (cart.discountTotal > 0) ...[
            CartSummaryItemRow(
              title: 'Total Discount',
              value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
              valueColor: const Color(0xFF15803D),
            ),
            const Gap(10),
          ],
          CartSummaryItemRow(
            title: 'Taxes',
            value: '₹${cart.taxTotal.toStringAsFixed(2)}',
          ),
        ],
        const Gap(14),
        CartPaymentModeSelector(selectedMode: paymentMode),
        const Gap(14),
        const CartPrintBillToggle(),
        const Gap(14),
        const FDivider(),
        const Gap(14),
        CartSummaryItemRow(
          title: 'Grand Total',
          value: '₹${cart.grandTotal.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }
}
