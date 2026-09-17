import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/orders/calendar_days_grid.dart';
import 'package:terminal/components/orders/calendar_month_header.dart';

export 'package:terminal/components/orders/calendar_month_header.dart';

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
  DateTime _viewMonth = DateTime.now();
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
    final currentStart = _rangeStart;
    if (currentStart == null || _rangeEnd != null) {
      setState(() {
        _rangeStart = date;
        _rangeEnd = null;
      });
      widget.onRangeSelected(DateTimeRange(start: date, end: date));
    } else {
      final start = date.isBefore(currentStart) ? date : currentStart;
      final end = date.isBefore(currentStart) ? currentStart : date;
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
          .shadowOnly(
            color: const Color(0x1A000000),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarMonthHeader(
            viewMonth: _viewMonth,
            onPreviousMonth: () => setState(
              () => _viewMonth = DateTime(
                _viewMonth.year,
                _viewMonth.month - 1,
              ),
            ),
            onNextMonth: () => setState(
              () => _viewMonth = DateTime(
                _viewMonth.year,
                _viewMonth.month + 1,
              ),
            ),
          ),
          const Gap(4),
          CalendarDaysGrid(
            viewMonth: _viewMonth,
            rangeStart: _rangeStart,
            rangeEnd: _rangeEnd,
            onDaySelected: _onDaySelected,
          ),
        ],
      ),
    );
  }
}
