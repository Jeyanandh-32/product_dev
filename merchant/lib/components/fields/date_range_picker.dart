import 'package:date_format/date_format.dart' as df;
import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/calendar.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:web/web.dart' as web;

class DateRangePicker extends SignalComponent {
  const DateRangePicker({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  final String? fromDate;
  final String? toDate;
  final ValueChanged<String?> onFromDateChanged;
  final ValueChanged<String?> onToDateChanged;

  @override
  SignalState<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends SignalState<DateRangePicker> {
  late String _tempFrom;
  late String _tempTo;

  String _cleanDate(String? str) {
    if (str == null || str.isEmpty) return '';
    final dateOnly = str.contains('T')
        ? str.split('T').first
        : str.split(' ').first;
    return dateOnly.trim();
  }

  String _formatDateForDisplay(String? dateStr) {
    final cleaned = _cleanDate(dateStr);
    if (cleaned.isEmpty) return '';
    final dt = DateTime.tryParse(cleaned);
    if (dt == null) return cleaned;
    return df.formatDate(dt.toLocal(), [df.dd, ' ', df.M, ' ', df.yyyy]);
  }

  String _getTodayString() => df.formatDate(DateTime.now().toLocal(), [
    df.yyyy,
    '-',
    df.mm,
    '-',
    df.dd,
  ]);

  String _getYesterdayString() => df.formatDate(
    DateTime.now().toLocal().subtract(const Duration(days: 1)),
    [df.yyyy, '-', df.mm, '-', df.dd],
  );

  String _getLast7DaysString() => df.formatDate(
    DateTime.now().toLocal().subtract(const Duration(days: 6)),
    [df.yyyy, '-', df.mm, '-', df.dd],
  );

  String _getStartOfMonthString() {
    final now = DateTime.now().toLocal();
    return df.formatDate(
      DateTime(now.year, now.month, 1),
      [df.yyyy, '-', df.mm, '-', df.dd],
    );
  }

  String _getEndOfMonthString() {
    final now = DateTime.now().toLocal();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return df.formatDate(lastDay, [df.yyyy, '-', df.mm, '-', df.dd]);
  }

  String _presetButtonClass(bool isSelected) {
    if (isSelected) {
      return 'btn btn-xs rounded-full border-0 shadow-none btn-primary text-white font-medium transition-colors';
    }
    return 'btn btn-xs rounded-full border-0 shadow-none bg-base-200 text-gray-700 hover:bg-primary hover:text-white font-normal transition-colors';
  }

  void _closeDropdown() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      final details = element.closest('details');
      if (details != null) {
        details.removeAttribute('open');
      }
    }
  }

  void _applyRange(String? from, String? to) {
    final cleanedFrom = _cleanDate(from);
    final cleanedTo = _cleanDate(to);
    component.onFromDateChanged(cleanedFrom.isEmpty ? null : cleanedFrom);
    component.onToDateChanged(cleanedTo.isEmpty ? null : cleanedTo);
    _closeDropdown();
  }

  String get _buttonText {
    final from = _cleanDate(component.fromDate);
    final to = _cleanDate(component.toDate);
    final today = _getTodayString();
    final monthStart = _getStartOfMonthString();
    final monthEnd = _getEndOfMonthString();

    if (from.isEmpty && to.isEmpty) {
      return 'All Time';
    }
    if (from == today && to == today) {
      return 'Today (${_formatDateForDisplay(today)})';
    }
    if (from == monthStart && to == monthEnd) {
      return 'This Month (${_formatDateForDisplay(monthStart)} - ${_formatDateForDisplay(monthEnd)})';
    }
    if (from.isNotEmpty && to.isNotEmpty) {
      if (from == to) {
        return _formatDateForDisplay(from);
      }
      return '${_formatDateForDisplay(from)} - ${_formatDateForDisplay(to)}';
    }
    if (from.isNotEmpty) {
      return 'From ${_formatDateForDisplay(from)}';
    }
    return 'To ${_formatDateForDisplay(to)}';
  }

  @override
  Component buildSignal(BuildContext context) {
    _tempFrom = _cleanDate(component.fromDate ?? _getTodayString());
    _tempTo = _cleanDate(component.toDate ?? _getTodayString());

    final today = _getTodayString();
    final yesterday = _getYesterdayString();
    final last7 = _getLast7DaysString();
    final monthStart = _getStartOfMonthString();
    final monthEnd = _getEndOfMonthString();

    final currentFrom = _cleanDate(component.fromDate);
    final currentTo = _cleanDate(component.toDate);

    final isToday = currentFrom == today && currentTo == today;
    final isYesterday = currentFrom == yesterday && currentTo == yesterday;
    final isLast7 = currentFrom == last7 && currentTo == today;
    final isThisMonth = currentFrom == monthStart && currentTo == monthEnd;
    final isAllTime = currentFrom.isEmpty && currentTo.isEmpty;

    return details(classes: 'dropdown dropdown-bottom dropdown-start inline-block', [
      summary(
        classes:
            'btn btn-sm rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3 font-medium flex items-center gap-2 shadow-2xs cursor-pointer list-none select-none',
        [
          Calendar(classes: 'w-3.5 h-3.5 text-primary'),
          span(classes: 'text-xs text-base-content font-medium', [
            .text(_buttonText),
          ]),
          ChevronDown(classes: 'w-3.5 h-3.5 opacity-60'),
        ],
      ),
      div(
        classes:
            'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-3 shadow-xl border border-border-medium w-80 flex flex-col gap-2.5',
        [
          div(classes: 'flex flex-col gap-1', [
            span(
              classes:
                  'text-2xs font-semibold text-gray-500 uppercase tracking-wider px-1',
              [.text('Quick Presets')],
            ),
            div(classes: 'flex flex-wrap gap-1.5', [
              button(
                classes: _presetButtonClass(isToday),
                onClick: () => _applyRange(today, today),
                [.text('Today')],
              ),
              button(
                classes: _presetButtonClass(isYesterday),
                onClick: () => _applyRange(yesterday, yesterday),
                [.text('Yesterday')],
              ),
              button(
                classes: _presetButtonClass(isLast7),
                onClick: () => _applyRange(last7, today),
                [.text('Last 7 Days')],
              ),
              button(
                classes: _presetButtonClass(isThisMonth),
                onClick: () => _applyRange(monthStart, monthEnd),
                [.text('This Month')],
              ),
              button(
                classes: _presetButtonClass(isAllTime),
                onClick: () => _applyRange(null, null),
                [.text('All Time')],
              ),
            ]),
          ]),
          div(classes: 'flex flex-col gap-1 pt-1 border-t border-border-light', [
            span(
              classes:
                  'text-2xs font-semibold text-gray-500 uppercase tracking-wider px-1',
              [.text('Custom Range')],
            ),
            div(classes: 'grid grid-cols-2 gap-2 mt-0.5', [
              div(classes: 'flex flex-col gap-0.5', [
                label(classes: 'text-2xs font-medium text-gray-600 px-1', [
                  .text('From Date'),
                ]),
                input(
                  type: InputType.date,
                  value: _tempFrom,
                  classes:
                      'input input-sm border border-border-medium bg-base-100 rounded-lg text-xs w-full focus:outline-none focus:border-primary',
                  onInput: (value) {
                    final val = value.toString().trim();
                    _tempFrom = _cleanDate(val);
                  },
                ),
              ]),
              div(classes: 'flex flex-col gap-0.5', [
                label(classes: 'text-2xs font-medium text-gray-600 px-1', [
                  .text('To Date'),
                ]),
                input(
                  type: InputType.date,
                  value: _tempTo,
                  classes:
                      'input input-sm border border-border-medium bg-base-100 rounded-lg text-xs w-full focus:outline-none focus:border-primary',
                  onInput: (value) {
                    final val = value.toString().trim();
                    _tempTo = _cleanDate(val);
                  },
                ),
              ]),
            ]),
          ]),
          div(
            classes:
                'flex justify-between items-center mt-0.5 border-t border-border-light pt-2',
            [
              button(
                classes:
                    'btn btn-xs btn-ghost text-error rounded-full font-medium',
                onClick: () => _applyRange(today, today),
                [.text('Reset to Today')],
              ),
              button(
                classes:
                    'btn btn-xs btn-primary rounded-full px-4 text-white font-medium',
                onClick: () => _applyRange(_tempFrom, _tempTo),
                [.text('Apply')],
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}
