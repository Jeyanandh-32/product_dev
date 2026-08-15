import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Renders quick preset date range buttons (Today, Yesterday, Last 7 Days, This Month, All Time).
class DatePickerPresetButtons extends StatelessComponent {
  final bool isToday;
  final bool isYesterday;
  final bool isLast7;
  final bool isThisMonth;
  final bool isAllTime;
  final String today;
  final String yesterday;
  final String last7;
  final String monthStart;
  final String monthEnd;
  final void Function(String? from, String? to) onSelectRange;

  const DatePickerPresetButtons({
    super.key,
    required this.isToday,
    required this.isYesterday,
    required this.isLast7,
    required this.isThisMonth,
    required this.isAllTime,
    required this.today,
    required this.yesterday,
    required this.last7,
    required this.monthStart,
    required this.monthEnd,
    required this.onSelectRange,
  });

  String _presetButtonClass(bool isSelected) {
    if (isSelected) {
      return 'btn btn-xs rounded-full border-0 shadow-none btn-primary text-white font-medium transition-colors';
    }
    return 'btn btn-xs rounded-full border-0 shadow-none bg-base-200 text-gray-700 hover:bg-primary hover:text-white font-normal transition-colors';
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-1', [
      span(
        classes:
            'text-2xs font-semibold text-gray-500 uppercase tracking-wider px-1',
        [.text('Quick Presets')],
      ),
      div(classes: 'flex flex-wrap gap-1.5', [
        button(
          classes: _presetButtonClass(isToday),
          onClick: () => onSelectRange(today, today),
          [.text('Today')],
        ),
        button(
          classes: _presetButtonClass(isYesterday),
          onClick: () => onSelectRange(yesterday, yesterday),
          [.text('Yesterday')],
        ),
        button(
          classes: _presetButtonClass(isLast7),
          onClick: () => onSelectRange(last7, today),
          [.text('Last 7 Days')],
        ),
        button(
          classes: _presetButtonClass(isThisMonth),
          onClick: () => onSelectRange(monthStart, monthEnd),
          [.text('This Month')],
        ),
        button(
          classes: _presetButtonClass(isAllTime),
          onClick: () => onSelectRange(null, null),
          [.text('All Time')],
        ),
      ]),
    ]);
  }
}
