import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/cart/cart_item_thumbnail.dart';
import 'package:terminal/components/cart/cart_item_trash_button.dart';
import 'package:terminal/components/cart/stepper_circle_button.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Single item card in the POS cart list with enhanced high-contrast text readability.
class CartItemRow extends StatelessWidget {
  final CartItem item;

  const CartItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .marginBottom(8)
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
          CartItemThumbnail(imageUrl: item.product.imageUrl),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.product.name,
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
                  '₹${item.product.sellingPrice.toStringAsFixed(2)} × ${item.quantity}',
                  style: TextStyler()
                      .fontSize(13)
                      .fontWeight(.w700)
                      .color(const Color(0xFF334155)),
                ),
              ],
            ),
          ),
          const Gap(8),
          _buildStepper(item),
          const Gap(10),
          CartItemTrashButton(
            onTap: () => CartController.removeItem(item.product.id),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(CartItem item) {
    return Box(
      style: BoxStyler()
          .height(34)
          .paddingAll(3)
          .color(const Color(0xFFF3F4F6))
          .borderRadiusAll(const Radius.circular(999))
          .borderAll(color: const Color(0xFFE5E7EB)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StepperCircleButton(
            icon: FLucideIcons.minus,
            size: 26,
            iconSize: 12,
            onTap: () => CartController.updateQuantity(
              item.product.id,
              item.quantity - 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: StyledText(
              '${item.quantity}',
              style: TextStyler()
                  .fontSize(13.5)
                  .fontWeight(.w900)
                  .color(TerminalColors.textPrimary),
            ),
          ),
          StepperCircleButton(
            icon: FLucideIcons.plus,
            size: 26,
            iconSize: 12,
            onTap: () => CartController.addItem(item.product),
          ),
        ],
      ),
    );
  }
}
