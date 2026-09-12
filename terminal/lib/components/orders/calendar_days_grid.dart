import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Renders the days grid of a monthly calendar with date range highlighting.
class CalendarDaysGrid extends StatelessWidget {
  final DateTime viewMonth;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final ValueChanged<DateTime> onDaySelected;

  const CalendarDaysGrid({
    super.key,
    required this.viewMonth,
    required this.rangeStart,
    required this.rangeEnd,
    required this.onDaySelected,
  });

  bool _isSame(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(viewMonth.year, viewMonth.month, 1);
    final daysInMonth = DateTime(viewMonth.year, viewMonth.month + 1, 0).day;
    final leadingEmpty = firstDay.weekday % 7;
    final rowCount = ((leadingEmpty + daysInMonth) / 7).ceil();

    return Column(
      children: List.generate(rowCount, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (col) {
            final dayNum = row * 7 + col - leadingEmpty + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const SizedBox(width: 32, height: 30);
            }

            final date = DateTime(viewMonth.year, viewMonth.month, dayNum);
            final start = rangeStart;
            final end = rangeEnd;
            final isStart = start != null && _isSame(date, start);
            final isEnd = end != null && _isSame(date, end);
            final inRange =
                start != null &&
                end != null &&
                date.isAfter(start) &&
                date.isBefore(end);
            final isSelected = isStart || isEnd;

            final bg = isSelected
                ? TerminalColors.primary
                : (inRange ? const Color(0xFFF1F5F9) : const Color(0x00000000));
            final fg = isSelected
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF0F172A);

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PressableBox(
                onPress: () => onDaySelected(date),
                style: BoxStyler()
                    .width(32)
                    .height(30)
                    .borderRadiusAll(const Radius.circular(6))
                    .color(bg)
                    .alignment(Alignment.center),
                child: StyledText(
                  '$dayNum',
                  style: TextStyler()
                      .fontSize(12)
                      .fontWeight(isSelected ? .w800 : .w500)
                      .color(fg),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
