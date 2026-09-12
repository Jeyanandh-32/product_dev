import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/stepper_circle_button.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Reactive quantity stepper controller with localized reactive boundary.
class ProductCardStepper extends StatelessWidget {
  final Product product;

  const ProductCardStepper({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final cart = cartSignal.value;
        final cartIndex = cart.items.indexWhere(
          (item) => item.product.id == product.id,
        );
        final isExisting = cartIndex >= 0;
        final currentQuantity = isExisting ? cart.items[cartIndex].quantity : 0;

        if (!isExisting) {
          return _AddButton(onTap: () => CartController.addItem(product));
        }

        return Box(
          style: BoxStyler()
              .width(double.infinity)
              .height(36)
              .paddingX(4)
              .paddingY(3)
              .color(const Color(0xFFF3F4F6))
              .borderRadiusAll(const Radius.circular(999))
              .borderAll(color: const Color(0xFFE5E7EB)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StepperCircleButton(
                icon: FLucideIcons.minus,
                size: 28,
                iconSize: 13,
                onTap: () => CartController.updateQuantity(
                  product.id,
                  currentQuantity - 1,
                ),
              ),
              StyledText(
                '$currentQuantity',
                style: TextStyler()
                    .fontSize(14)
                    .fontWeight(.w900)
                    .color(TerminalColors.textPrimary),
              ),
              StepperCircleButton(
                icon: FLucideIcons.plus,
                size: 28,
                iconSize: 13,
                onTap: () => CartController.addItem(product),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final fgColor = _isHovered
        ? const Color(0xFFFFFFFF)
        : TerminalColors.textPrimary;
    final bgColor = _isHovered
        ? TerminalColors.primary
        : const Color(0xFFF3F4F6);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        onPress: widget.onTap,
        style: BoxStyler()
            .color(bgColor)
            .width(double.infinity)
            .height(36)
            .borderRadiusAll(const Radius.circular(12))
            .borderAll(color: bgColor)
            .onPressed(BoxStyler().scale(0.98)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FLucideIcons.plus, size: 14, color: fgColor),
            const SizedBox(width: 4),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
