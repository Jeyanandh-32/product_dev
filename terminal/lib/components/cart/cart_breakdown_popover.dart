import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/cart/cart_summary_item_row.dart';
import 'package:terminal/signals/cart_signal.dart';

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
          .color(const Color(0xFFFFFFFF))
          .borderRadiusAll(const Radius.circular(16))
          .borderAll(color: const Color(0xFFCBD5E1), width: 1.2)
          .shadowOnly(
            color: const Color(0x1A000000),
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
                    .fontSize(16)
                    .fontWeight(.w900)
                    .color(const Color(0xFF000000)),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: onClose,
                  style: BoxStyler()
                      .paddingAll(4)
                      .borderRadiusAll(const Radius.circular(6))
                      .color(const Color(0xFFF1F5F9)),
                  child: const Icon(
                    FLucideIcons.x,
                    size: 14,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
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
          if (cart.discountTotal > 0) ...[
            const Gap(10),
            CartSummaryItemRow(
              title: 'Discount Applied',
              value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
              valueColor: const Color(0xFF15803D),
            ),
          ],
          const Gap(10),
          CartSummaryItemRow(
            title: 'Taxes',
            value: '₹${cart.taxTotal.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}
