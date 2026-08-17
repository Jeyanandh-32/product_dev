import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Clean animated logout action button with hover inversion using Mix [PressableBox].
class TerminalLogoutButton extends StatefulWidget {
  const TerminalLogoutButton({super.key});

  @override
  State<TerminalLogoutButton> createState() => _TerminalLogoutButtonState();
}

class _TerminalLogoutButtonState extends State<TerminalLogoutButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final fgColor =
        _isHovered ? const Color(0xFFFFFFFF) : const Color(0xFFDC2626);
    final bgColor =
        _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFEF2F2);
    final borderColor =
        _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFECACA);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        onPress: () => logoutTerminal(),
        style: BoxStyler()
            .paddingX(14)
            .paddingY(7)
            .borderRadiusAll(const Radius.circular(999))
            .color(bgColor)
            .borderAll(color: borderColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FLucideIcons.logOut,
              size: 14,
              color: fgColor,
            ),
            const Gap(6),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 12,
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
