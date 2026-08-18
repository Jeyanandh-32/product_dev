import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// High-contrast navigation trigger pill with matching button height and large readable typography.
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
        final isOpen = controller.status == AnimationStatus.completed ||
            controller.status == AnimationStatus.forward;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: controller.toggle,
            style: BoxStyler()
                .height(38)
                .paddingX(14)
                .borderRadiusAll(const Radius.circular(999))
                .color(isOpen ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF))
                .borderAll(color: isOpen ? const Color(0xFF000000) : theme.colors.border, width: isOpen ? 1.5 : 1.0)
                .shadowOnly(color: const Color(0x06000000), offset: const Offset(0, 1), blurRadius: 2)
                .alignment(Alignment.center)
                .onHovered(
                  BoxStyler()
                      .color(const Color(0xFFF8FAFC))
                      .borderAll(color: const Color(0xFF94A3B8)),
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StyledText(
                  label,
                  style: TextStyler()
                      .fontSize(13.5)
                      .fontWeight(.w800)
                      .color(const Color(0xFF000000)),
                ),
                const Gap(6),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: const Icon(
                    FLucideIcons.chevronDown,
                    size: 14,
                    color: Color(0xFF000000),
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
