import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Clean animated logout action button with matching 38px height and responsive icon/text.
class TerminalLogoutButton extends StatefulWidget {
  const TerminalLogoutButton({super.key});

  @override
  State<TerminalLogoutButton> createState() => _TerminalLogoutButtonState();
}

class _TerminalLogoutButtonState extends State<TerminalLogoutButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isCompact = context.screenWidth < 800;
    final fgColor = _isHovered ? const Color(0xFFFFFFFF) : const Color(0xFFDC2626);
    final bgColor = _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFEF2F2);
    final borderColor = _isHovered ? const Color(0xFFDC2626) : const Color(0xFFFECACA);

    final baseStyle = BoxStyler()
        .height(38)
        .paddingX(isCompact ? 0 : 14)
        .borderRadiusAll(const Radius.circular(999))
        .color(bgColor)
        .borderAll(color: borderColor)
        .shadowOnly(color: const Color(0x06000000), offset: const Offset(0, 1), blurRadius: 2)
        .alignment(Alignment.center);

    final buttonStyle = isCompact ? baseStyle.width(38) : baseStyle;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        onPress: logoutTerminal,
        style: buttonStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FLucideIcons.logOut, size: 14.5, color: fgColor),
            if (!isCompact) ...[
              const Gap(6),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: fgColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
