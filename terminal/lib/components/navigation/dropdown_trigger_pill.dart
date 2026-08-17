import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Interactive pill trigger button with animated chevron indicator using Mix.
class DropdownTriggerPill extends StatelessWidget {
  final String label;
  final FPopoverController controller;

  const DropdownTriggerPill({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final isOpen =
            controller.status == AnimationStatus.completed ||
            controller.status == AnimationStatus.forward;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: controller.toggle,
            style: BoxStyler()
                .paddingX(12)
                .paddingY(6)
                .borderRadiusAll(const Radius.circular(999))
                .color(
                  isOpen
                      ? theme.colors.background
                      : const Color(0xFFFFFFFF),
                )
                .borderAll(
                  color: isOpen
                      ? const Color(0xFFCBD5E1)
                      : theme.colors.border,
                )
                .onHovered(
                  BoxStyler()
                      .color(theme.colors.background)
                      .borderAll(color: const Color(0xFFCBD5E1)),
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StyledText(
                  label,
                  style: TextStyler()
                      .fontSize(12.5)
                      .fontWeight(.w700)
                      .color(theme.colors.primary),
                ),
                const Gap(5),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: const Icon(
                    FLucideIcons.chevronDown,
                    size: 13,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
