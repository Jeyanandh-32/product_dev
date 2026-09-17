import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Header with month name, navigation arrows, and weekday labels for calendar popover.
class CalendarMonthHeader extends StatelessWidget {
  final DateTime viewMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarMonthHeader({
    super.key,
    required this.viewMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .width(26)
            .height(26)
            .borderRadiusAll(const Radius.circular(6))
            .alignment(Alignment.center),
        child: Icon(icon, size: 14, color: const Color(0xFF0F172A)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(
              '${_monthNames[viewMonth.month - 1]} ${viewMonth.year}',
              style: TextStyler()
                  .fontSize(13)
                  .fontWeight(.w800)
                  .color(TerminalColors.textPrimary),
            ),
            Row(
              children: [
                _navBtn(FLucideIcons.chevronLeft, onPreviousMonth),
                const Gap(4),
                _navBtn(FLucideIcons.chevronRight, onNextMonth),
              ],
            ),
          ],
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
              .map(
                (d) => SizedBox(
                  width: 32,
                  child: Center(
                    child: StyledText(
                      d,
                      style: TextStyler()
                          .fontSize(11)
                          .fontWeight(.w700)
                          .color(const Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
