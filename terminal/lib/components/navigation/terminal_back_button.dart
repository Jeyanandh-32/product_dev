import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

/// Circular back navigation button matching the customer web app (rounded-full with hover inversion).
class TerminalBackButton extends StatelessWidget {
  final VoidCallback? onPress;

  const TerminalBackButton({super.key, this.onPress});

  @override
  Widget build(BuildContext context) {
    final effectiveOnPress =
        onPress ?? () => GoRouter.maybeOf(context)?.pop();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: effectiveOnPress,
        style: BoxStyler()
            .width(36)
            .height(36)
            .borderRadiusAll(const Radius.circular(999))
            .color(const Color(0xFFF1F5F9))
            .alignment(Alignment.center)
            .onHovered(
              BoxStyler()
                  .color(const Color(0xFF000000))
                  .shadowOnly(
                    color: const Color(0x26000000),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
            ),
        child: const _BackButtonIcon(),
      ),
    );
  }
}

class _BackButtonIcon extends StatelessWidget {
  const _BackButtonIcon();

  @override
  Widget build(BuildContext context) {
    return StyledIcon(
      icon: FLucideIcons.arrowLeft,
      style: IconStyler()
          .size(18)
          .color(const Color(0xFF0F172A))
          .onHovered(IconStyler().color(const Color(0xFFFFFFFF))),
    );
  }
}
