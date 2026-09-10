import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/calendar.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/fields/date_picker_helper.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:web/web.dart' as web;

/// Single date selection input with quick presets and calendar dialog popup.
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
  String _tempDate = '';

  String _presetButtonClass(bool isSelected) => isSelected
      ? 'btn btn-xs rounded-full border-0 shadow-none btn-primary text-white font-medium transition-colors cursor-pointer'
      : 'btn btn-xs rounded-full border-0 shadow-none bg-base-200 text-gray-700 hover:bg-primary hover:text-white font-normal transition-colors cursor-pointer';

  void _closeDropdown() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      element.closest('details')?.removeAttribute('open');
    }
  }

  void _applyDate(String dateStr) {
    final cleaned = DatePickerHelper.cleanDate(dateStr);
    component.onDateChanged(cleaned);
    _closeDropdown();
  }

  String get _buttonText {
    final cleaned = DatePickerHelper.cleanDate(component.date);
    final today = DatePickerHelper.getTodayString();
    final yesterday = DatePickerHelper.getYesterdayString();

    if (cleaned == today) {
      return 'Today (${DatePickerHelper.formatDateForDisplay(today)})';
    }
    if (cleaned == yesterday) {
      return 'Yesterday (${DatePickerHelper.formatDateForDisplay(yesterday)})';
    }
    return DatePickerHelper.formatDateForDisplay(cleaned);
  }

  @override
  Component buildSignal(BuildContext context) {
    _tempDate = DatePickerHelper.cleanDate(component.date);
    final today = DatePickerHelper.getTodayString();
    final yesterday = DatePickerHelper.getYesterdayString();

    final isToday = _tempDate == today;
    final isYesterday = _tempDate == yesterday;

    return details(
      classes: 'dropdown dropdown-bottom dropdown-start w-full sm:w-auto inline-block',
      [
        summary(
          classes: 'btn btn-sm rounded-xl sm:rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3.5 font-medium flex items-center justify-between sm:justify-start gap-2 shadow-2xs cursor-pointer list-none select-none w-full sm:w-auto h-9',
          [
            div(classes: 'flex items-center gap-2 truncate', [
              Calendar(classes: 'w-3.5 h-3.5 text-primary shrink-0'),
              span(classes: 'text-xs text-base-content font-medium truncate', [
                .text(_buttonText),
              ]),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60 shrink-0'),
          ],
        ),
        div(
          classes: 'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-3 shadow-xl border border-border-medium w-72 max-w-[calc(100vw-2.5rem)] flex flex-col gap-2.5',
          [
            div(classes: 'flex flex-col gap-1', [
              span(
                classes: 'text-2xs font-semibold text-gray-500 uppercase tracking-wider px-1',
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
                  classes: 'text-2xs font-semibold text-slate-500 uppercase tracking-wider px-1',
                  [.text('Select Date')],
                ),
                div(classes: 'flex flex-col gap-0.5 mt-0.5', [
                  input(
                    type: InputType.date,
                    value: _tempDate,
                    classes: 'input input-sm border border-border-medium bg-white rounded-[10px] text-xs w-full',
                    onInput: (val) => _tempDate = DatePickerHelper.cleanDate(
                      val.toString().trim(),
                    ),
                  ),
                ]),
              ],
            ),
            div(
              classes: 'flex justify-between items-center mt-0.5 border-t border-border-light pt-2',
              [
                button(
                  classes: 'btn btn-xs btn-ghost text-error rounded-full font-medium cursor-pointer',
                  onClick: () => _applyDate(today),
                  [.text('Reset to Today')],
                ),
                button(
                  classes: 'btn btn-xs btn-primary rounded-full px-4 text-white font-medium cursor-pointer',
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
