import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';

/// Clean trash action button with hover inversion using Mix [PressableBox].
class CartItemTrashButton extends StatefulWidget {
  final VoidCallback onTap;

  const CartItemTrashButton({super.key, required this.onTap});

  @override
  State<CartItemTrashButton> createState() => _CartItemTrashButtonState();
}

class _CartItemTrashButtonState extends State<CartItemTrashButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        onPress: widget.onTap,
        style: BoxStyler()
            .width(32)
            .height(32)
            .borderRadiusAll(const Radius.circular(8))
            .color(
              _isHovered ? const Color(0xFFDC2626) : const Color(0xFFF9FAFB),
            )
            .borderAll(
              color: _isHovered ? const Color(0xFFDC2626) : const Color(0xFFE5E7EB),
            ),
        child: Center(
          child: Icon(
            FLucideIcons.trash2,
            size: 14,
            color: _isHovered ? const Color(0xFFFFFFFF) : const Color(0xFFDC2626),
          ),
        ),
      ),
    );
  }
}
