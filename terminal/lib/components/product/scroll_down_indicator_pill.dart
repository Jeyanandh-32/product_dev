import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';

/// Reusable animated floating pill indicating more items are available to scroll down.
class ScrollDownIndicatorPill extends StatelessWidget {
  final bool visible;
  final ScrollController controller;
  final double scrollDelta;

  const ScrollDownIndicatorPill({
    super.key,
    required this.visible,
    required this.controller,
    this.scrollDelta = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: visible ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: !visible,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (!controller.hasClients) return;
                controller.animateTo(
                  controller.offset + scrollDelta,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              },
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFF334155), width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FLucideIcons.chevronDown, size: 15, color: Color(0xFFFFFFFF)),
                      Gap(6),
                      Text(
                        'More items below',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
