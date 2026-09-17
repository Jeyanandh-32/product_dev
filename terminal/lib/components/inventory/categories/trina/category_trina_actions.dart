import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Edit action button for category trina grid rows.
class CategoryTrinaEditButton extends StatelessWidget {
  final VoidCallback onTap;

  const CategoryTrinaEditButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .width(30)
            .height(30)
            .borderRadiusAll(const Radius.circular(8))
            .color(TerminalColors.secondaryBackground)
            .alignment(Alignment.center)
            .onHovered(BoxStyler().color(TerminalColors.controlHover)),
        child: const Icon(
          FLucideIcons.squarePen,
          size: 14.5,
          color: TerminalColors.textLight,
        ),
      ),
    );
  }
}
