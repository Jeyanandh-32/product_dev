import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean chevron navigation button for pagination toolbars.
class PaginationNavButton extends StatelessWidget {
  /// Creates a pagination navigation button.
  const PaginationNavButton({
    super.key,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  /// Icon displayed inside the button (e.g. chevronLeft, chevronRight).
  final IconData icon;

  /// Whether the button is active and can be clicked.
  final bool isEnabled;

  /// Callback executed when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: PressableBox(
        onPress: isEnabled ? onTap : null,
        style: BoxStyler()
            .width(32)
            .height(32)
            .borderRadiusAll(const Radius.circular(8))
            .borderAll(
              color: isEnabled
                  ? TerminalColors.border
                  : TerminalColors.borderSubtle,
            )
            .color(
              isEnabled
                  ? TerminalColors.surface
                  : TerminalColors.pageBackground,
            )
            .alignment(Alignment.center),
        child: Icon(
          icon,
          size: 15,
          color: isEnabled
              ? TerminalColors.textPrimary
              : TerminalColors.textMuted,
        ),
      ),
    );
  }
}
