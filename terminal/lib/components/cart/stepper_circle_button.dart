import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Interactive circular button for steppers with hover inversion.
class StepperCircleButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final double size;
  final VoidCallback onTap;

  const StepperCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconSize = 13,
    this.size = 28,
  });

  @override
  State<StepperCircleButton> createState() => _StepperCircleButtonState();
}

class _StepperCircleButtonState extends State<StepperCircleButton> {
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
            .width(widget.size)
            .height(widget.size)
            .borderRadiusAll(const Radius.circular(999))
            .color(_isHovered ? TerminalColors.primary : TerminalColors.surface)
            .borderAll(
              color: _isHovered
                  ? TerminalColors.primary
                  : const Color(0xFFE5E7EB),
            )
            .shadowOnly(
              color: const Color(0x0D000000),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: _isHovered
                ? TerminalColors.textWhite
                : TerminalColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
