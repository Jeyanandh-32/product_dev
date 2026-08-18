import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Clean animated Clear All button with high-contrast text and hover inversion.
class CartClearAllButton extends StatefulWidget {
  const CartClearAllButton({super.key});

  @override
  State<CartClearAllButton> createState() => _CartClearAllButtonState();
}

class _CartClearAllButtonState extends State<CartClearAllButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final fgColor = _isHovered ? const Color(0xFFFFFFFF) : const Color(0xFFDC2626);
    final bgColor = _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFEF2F2);
    final borderColor = _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFECACA);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        onPress: CartController.clear,
        style: BoxStyler()
            .paddingX(14)
            .paddingY(6.5)
            .borderRadiusAll(const Radius.circular(999))
            .color(bgColor)
            .borderAll(color: borderColor),
        child: StyledText(
          'Clear All',
          style: TextStyler()
              .fontSize(13)
              .fontWeight(.w800)
              .color(fgColor),
        ),
      ),
    );
  }
}
