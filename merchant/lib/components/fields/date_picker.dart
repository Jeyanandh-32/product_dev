import 'package:date_format/date_format.dart' as df;
import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/calendar.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:web/web.dart' as web;

class DatePicker extends SignalComponent {
  const DatePicker({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  final String? date;
  final ValueChanged<String> onDateChanged;

  @override
  SignalState<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends SignalState<DatePicker> {
  late String _tempDate;

  String _cleanDate(String? str) {
    if (str == null || str.isEmpty) return _getTodayString();
    final dateOnly = str.contains('T')
        ? str.split('T').first
        : str.split(' ').first;
    return dateOnly.trim();
  }

  String _formatDateForDisplay(String? dateStr) {
    final cleaned = _cleanDate(dateStr);
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

  String _presetButtonClass(bool isSelected) {
    if (isSelected) {
      return 'btn btn-xs rounded-full border-0 shadow-none btn-primary text-white font-medium transition-colors cursor-pointer';
    }
    return 'btn btn-xs rounded-full border-0 shadow-none bg-base-200 text-gray-700 hover:bg-primary hover:text-white font-normal transition-colors cursor-pointer';
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

  void _applyDate(String dateStr) {
    final cleaned = _cleanDate(dateStr);
    component.onDateChanged(cleaned);
    _closeDropdown();
  }

  String get _buttonText {
    final cleaned = _cleanDate(component.date);
    final today = _getTodayString();
    final yesterday = _getYesterdayString();

    if (cleaned == today) {
      return 'Today (${_formatDateForDisplay(today)})';
    }
    if (cleaned == yesterday) {
      return 'Yesterday (${_formatDateForDisplay(yesterday)})';
    }
    return _formatDateForDisplay(cleaned);
  }

  @override
  Component buildSignal(BuildContext context) {
    _tempDate = _cleanDate(component.date);
    final today = _getTodayString();
    final yesterday = _getYesterdayString();

    final isToday = _tempDate == today;
    final isYesterday = _tempDate == yesterday;

    return details(
      classes: 'dropdown dropdown-bottom dropdown-start inline-block',
      [
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
              'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-3 shadow-xl border border-border-medium w-72 flex flex-col gap-2.5',
          [
            div(classes: 'flex flex-col gap-1', [
              span(
                classes:
                    'text-2xs font-semibold text-gray-500 uppercase tracking-wider px-1',
                [.text('Quick Selection')],
              ),
              div(classes: 'flex flex-wrap gap-1.5', [
                button(
                  classes: _presetButtonClass(isToday),
                  onClick: () => _applyDate(today),
                  [.text('Today')],
                ),
                button(
                  classes: _presetButtonClass(isYesterday),
                  onClick: () => _applyDate(yesterday),
                  [.text('Yesterday')],
                ),
              ]),
            ]),
            div(
              classes: 'flex flex-col gap-1 pt-1 border-t border-border-light',
              [
                span(
                  classes:
                      'text-2xs font-semibold text-gray-500 uppercase tracking-wider px-1',
                  [.text('Select Date')],
                ),
                div(classes: 'flex flex-col gap-0.5 mt-0.5', [
                  input(
                    type: InputType.date,
                    value: _tempDate,
                    classes:
                        'input input-sm border border-border-medium bg-base-100 rounded-lg text-xs w-full focus:outline-none focus:border-primary',
                    onInput: (value) {
                      final val = value.toString().trim();
                      _tempDate = _cleanDate(val);
                    },
                  ),
                ]),
              ],
            ),
            div(
              classes:
                  'flex justify-between items-center mt-0.5 border-t border-border-light pt-2',
              [
                button(
                  classes:
                      'btn btn-xs btn-ghost text-error rounded-full font-medium cursor-pointer',
                  onClick: () => _applyDate(today),
                  [.text('Reset to Today')],
                ),
                button(
                  classes:
                      'btn btn-xs btn-primary rounded-full px-4 text-white font-medium cursor-pointer',
                  onClick: () => _applyDate(_tempDate),
                  [.text('Apply')],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
