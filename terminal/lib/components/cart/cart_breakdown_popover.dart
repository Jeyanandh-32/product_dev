import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/cart/cart_summary_item_row.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme.dart';

/// Overlay popover card displaying full order metrics, taxes, and applied discounts.
class CartBreakdownPopover extends StatelessWidget {
  final CartState cart;
  final VoidCallback onClose;

  const CartBreakdownPopover({
    super.key,
    required this.cart,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .width(300)
          .paddingAll(16)
          .color(TerminalColors.surface)
          .borderRadiusAll(const Radius.circular(16))
          .borderAll(color: TerminalColors.border, width: 1.0)
          .shadowOnly(
            color: const Color(0x14000000),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                'Order Breakdown',
                style: TextStyler()
                    .fontSize(15)
                    .fontWeight(.w800)
                    .color(const Color(0xFF0F172A)),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: onClose,
                  style: BoxStyler()
                      .width(26)
                      .height(26)
                      .borderRadiusAll(const Radius.circular(999))
                      .color(const Color(0xFFF1F5F9))
                      .alignment(Alignment.center)
                      .onHovered(BoxStyler().color(const Color(0xFFE2E8F0))),
                  child: const Icon(
                    FLucideIcons.x,
                    size: 13.5,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const Gap(14),
          CartSummaryItemRow.popover(
            title: 'Total No of Items',
            value: '${cart.noOfItems}',
          ),
          const Gap(10),
          CartSummaryItemRow.popover(
            title: 'Total Order Quantity',
            value: '${cart.orderQuantity}',
          ),
          const Gap(10),
          CartSummaryItemRow.popover(
            title: 'Subtotal',
            value: '₹${cart.subtotal.toStringAsFixed(2)}',
          ),
          if (cart.discountTotal > 0) ...[
            const Gap(10),
            CartSummaryItemRow.popover(
              title: 'Discount Applied',
              value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
              valueColor: const Color(0xFF15803D),
            ),
          ],
          const Gap(10),
          CartSummaryItemRow.popover(
            title: 'Taxes',
            value: '₹${cart.taxTotal.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}
