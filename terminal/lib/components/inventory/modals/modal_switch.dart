import 'package:flutter/widgets.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean, proportional iOS/Tailwind-style toggle switch for terminal modals.
class ModalSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ModalSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 42,
          height: 24,
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            color: value ? TerminalColors.primary : const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 19,
            height: 19,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x28000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
