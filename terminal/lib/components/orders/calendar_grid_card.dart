import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

const _monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

/// Compact calendar month grid card with single day and range selection for date filtering.
class CalendarGridCard extends StatefulWidget {
  final DateTimeRange? initialRange;
  final ValueChanged<DateTimeRange> onRangeSelected;

  const CalendarGridCard({
    super.key,
    this.initialRange,
    required this.onRangeSelected,
  });

  @override
  State<CalendarGridCard> createState() => _CalendarGridCardState();
}

class _CalendarGridCardState extends State<CalendarGridCard> {
  late DateTime _viewMonth;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(now.year, now.month);
    _rangeStart = widget.initialRange?.start;
    _rangeEnd = widget.initialRange?.end;
  }

  void _onDaySelected(DateTime date) {
    if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
      setState(() {
        _rangeStart = date;
        _rangeEnd = null;
      });
      widget.onRangeSelected(DateTimeRange(start: date, end: date));
    } else {
      final start = date.isBefore(_rangeStart!) ? date : _rangeStart!;
      final end = date.isBefore(_rangeStart!) ? _rangeStart! : date;
      setState(() {
        _rangeStart = start;
        _rangeEnd = end;
      });
      widget.onRangeSelected(DateTimeRange(start: start, end: end));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .width(280)
          .color(const Color(0xFFFFFFFF))
          .paddingAll(12)
          .borderRadiusAll(const Radius.circular(12))
          .borderAll(color: const Color(0xFFE2E8F0))
          .shadowOnly(color: const Color(0x1A000000), offset: const Offset(0, 4), blurRadius: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText('${_monthNames[_viewMonth.month - 1]} ${_viewMonth.year}',
                  style: TextStyler().fontSize(13).fontWeight(.w800).color(const Color(0xFF000000))),
              Row(
                children: [
                  _navBtn(FLucideIcons.chevronLeft, () => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1))),
                  const Gap(4),
                  _navBtn(FLucideIcons.chevronRight, () => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1))),
                ],
              ),
            ],
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map((d) => SizedBox(width: 32, child: Center(child: StyledText(d, style: TextStyler().fontSize(11).fontWeight(.w700).color(const Color(0xFF94A3B8))))))
                .toList(),
          ),
          const Gap(4),
          _buildDays(),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler().width(26).height(26).borderRadiusAll(const Radius.circular(6)).alignment(Alignment.center),
        child: Icon(icon, size: 14, color: const Color(0xFF0F172A)),
      ),
    );
  }

  Widget _buildDays() {
    final firstDay = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final leadingEmpty = firstDay.weekday % 7;
    final rowCount = ((leadingEmpty + daysInMonth) / 7).ceil();

    return Column(
      children: List.generate(rowCount, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (col) {
            final dayNum = row * 7 + col - leadingEmpty + 1;
            if (dayNum < 1 || dayNum > daysInMonth) return const SizedBox(width: 32, height: 30);

            final date = DateTime(_viewMonth.year, _viewMonth.month, dayNum);
            final isStart = _rangeStart != null && _isSame(date, _rangeStart!);
            final isEnd = _rangeEnd != null && _isSame(date, _rangeEnd!);
            final inRange = _rangeStart != null && _rangeEnd != null && date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!);
            final isSelected = isStart || isEnd;

            final bg = isSelected ? const Color(0xFF000000) : (inRange ? const Color(0xFFF1F5F9) : const Color(0x00000000));
            final fg = isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PressableBox(
                onPress: () => _onDaySelected(date),
                style: BoxStyler().width(32).height(30).borderRadiusAll(const Radius.circular(6)).color(bg).alignment(Alignment.center),
                child: StyledText('$dayNum', style: TextStyler().fontSize(12).fontWeight(isSelected ? .w800 : .w500).color(fg)),
              ),
            );
          }),
        );
      }),
    );
  }

  bool _isSame(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}
