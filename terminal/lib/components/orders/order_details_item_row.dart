import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/cart/cart_item_thumbnail.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Single item card in the POS Order Details receipt list matching [CartItemRow].
class OrderDetailsItemRow extends StatelessWidget {
  final OrderItem item;
  final int index;

  const OrderDetailsItemRow({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final itemName = item.product?.name ?? 'Item ${index + 1}';
    final itemTotal = item.unitPrice * item.quantity;

    return Box(
      style: BoxStyler()
          .paddingAll(12)
          .borderRadiusAll(const Radius.circular(16))
          .color(const Color(0xFFFFFFFF))
          .borderAll(color: const Color(0xFFE5E7EB))
          .shadowOnly(
            color: const Color(0x08000000),
            offset: const Offset(0, 2),
            blurRadius: 3,
          )
          .onHovered(
            BoxStyler()
                .borderAll(color: TerminalColors.primary)
                .shadowOnly(
                  color: const Color(0x10000000),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CartItemThumbnail(imageUrl: item.product?.imageUrl),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  itemName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: TerminalColors.textPrimary,
                  ),
                ),
                const Gap(3),
                StyledText(
                  '₹${item.unitPrice.toStringAsFixed(2)} × ${item.quantity}',
                  style: TextStyler()
                      .fontSize(13)
                      .fontWeight(.w700)
                      .color(const Color(0xFF334155)),
                ),
              ],
            ),
          ),
          const Gap(10),
          StyledText(
            '₹${itemTotal.toStringAsFixed(2)}',
            style: TextStyler()
                .fontSize(16)
                .fontWeight(.w900)
                .color(TerminalColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
