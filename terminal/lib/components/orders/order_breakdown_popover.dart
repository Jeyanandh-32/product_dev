import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/cart/cart_summary_item_row.dart';

/// Overlay popover card displaying additional order metrics, item counts, and online fees.
class OrderBreakdownPopover extends StatelessWidget {
  final Order order;
  final VoidCallback onClose;

  const OrderBreakdownPopover({
    super.key,
    required this.order,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuantity = order.items.fold<int>(
      0,
      (sum, i) => sum + i.quantity,
    );
    final isOnline =
        order.source == OrderSource.web ||
        order.source == OrderSource.mobileApp;

    return Box(
      style: BoxStyler()
          .width(290)
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
              Expanded(
                child: StyledText(
                  'Additional Details',
                  style: TextStyler()
                      .fontSize(15)
                      .fontWeight(.w800)
                      .color(const Color(0xFF0F172A)),
                ),
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
            value: '${order.items.length}',
          ),
          const Gap(8),
          CartSummaryItemRow.popover(
            title: 'Total Order Quantity',
            value: '$totalQuantity',
          ),
          if (order.platformFee > 0 || isOnline) ...[
            const Gap(8),
            CartSummaryItemRow.popover(
              title: 'Platform Fee (1.99%)',
              value: order.platformFee > 0
                  ? '₹${order.platformFee.toStringAsFixed(2)}'
                  : 'Free (₹0.00)',
            ),
          ],
          if (isOnline) ...[
            const Gap(8),
            CartSummaryItemRow.popover(
              title: 'Gateway Charges (PhonePe)',
              value: order.gatewayCharges > 0
                  ? '₹${order.gatewayCharges.toStringAsFixed(2)}'
                  : 'Free (₹0.00)',
              valueColor: order.gatewayCharges > 0
                  ? null
                  : const Color(0xFF15803D),
            ),
          ],
        ],
      ),
    );
  }
}
