import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/cart/cart_breakdown_popover.dart';
import 'package:terminal/components/cart/cart_payment_mode_selector.dart';
import 'package:terminal/components/cart/cart_print_bill_toggle.dart';
import 'package:terminal/components/cart/cart_summary_item_row.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme.dart';

/// Clean totals breakdown with floating popover breakdown overlay to keep cart item list at maximum height.
class CartTotalsBreakdown extends StatefulWidget {
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
  State<CartTotalsBreakdown> createState() => _CartTotalsBreakdownState();
}

class _CartTotalsBreakdownState extends State<CartTotalsBreakdown> with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyledText('Order Summary', style: TextStyler().fontSize(17.5).fontWeight(.w900).color(const Color(0xFF000000))),
            FTheme(
              data: TerminalTheme.light(false),
              child: FPopover(
                control: .managed(controller: _controller),
                popoverAnchor: Alignment.bottomRight,
                childAnchor: Alignment.topRight,
                popoverBuilder: (context, controller) => CartBreakdownPopover(
                  cart: widget.cart,
                  paymentMode: widget.paymentMode,
                  discountController: widget.discountController,
                  onClose: _controller.toggle,
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: _controller.toggle,
                    style: BoxStyler()
                        .paddingX(10)
                        .paddingY(5)
                        .borderRadiusAll(const Radius.circular(8))
                        .color(const Color(0xFFF1F5F9))
                        .borderAll(color: const Color(0xFFE2E8F0))
                        .alignment(Alignment.center)
                        .onHovered(BoxStyler().color(const Color(0xFF000000))),
                    child: Row(
                      children: [
                        StyledText(
                          'Details',
                          style: TextStyler().fontSize(12.5).fontWeight(.w800).color(const Color(0xFF0F172A)).onHovered(TextStyler().color(const Color(0xFFFFFFFF))),
                        ),
                        const Gap(4),
                        StyledIcon(
                          icon: FLucideIcons.chevronUp,
                          style: IconStyler().size(13.5).color(const Color(0xFF0F172A)).onHovered(IconStyler().color(const Color(0xFFFFFFFF))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(14),
        CartPaymentModeSelector(selectedMode: widget.paymentMode),
        const Gap(14),
        const CartPrintBillToggle(),
        const Gap(14),
        const FDivider(),
        const Gap(14),
        CartSummaryItemRow(title: 'Grand Total', value: '₹${widget.cart.grandTotal.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }
}
