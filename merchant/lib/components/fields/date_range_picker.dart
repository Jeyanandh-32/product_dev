import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/calendar.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/fields/custom_date_range_inputs.dart';
import 'package:merchant/components/fields/date_picker_preset_buttons.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/utils/date_range_utils.dart';
import 'package:web/web.dart' as web;

/// Interactive dropdown date range picker with quick presets and custom start/end date inputs.
class DateRangePicker extends SignalComponent {
  const DateRangePicker({
    super.key,
    required this.fromDate,
    required this.toDate,
    this.onChanged,
    this.onFromDateChanged,
    this.onToDateChanged,
  });

  final String? fromDate;
  final String? toDate;
  final void Function(String? fromDate, String? toDate)? onChanged;
  final ValueChanged<String?>? onFromDateChanged;
  final ValueChanged<String?>? onToDateChanged;

  @override
  SignalState<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends SignalState<DateRangePicker> {
  String _tempFrom = '';
  String _tempTo = '';

  void _closeDropdown() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      final details = element.closest('details');
      details?.removeAttribute('open');
    }
  }

  void _applyRange(String? from, String? to) {
    final cleanedFrom = DateRangeUtils.cleanDate(from);
    final cleanedTo = DateRangeUtils.cleanDate(to);
    final f = cleanedFrom.isEmpty ? null : cleanedFrom;
    final t = cleanedTo.isEmpty ? null : cleanedTo;
    final onChanged = component.onChanged;
    if (onChanged != null) {
      onChanged(f, t);
    } else {
      component.onFromDateChanged?.call(f);
      component.onToDateChanged?.call(t);
    }
    _closeDropdown();
  }

  @override
  Component buildSignal(BuildContext context) {
    _tempFrom = DateRangeUtils.cleanDate(
      component.fromDate ?? DateRangeUtils.getTodayString(),
    );
    _tempTo = DateRangeUtils.cleanDate(
      component.toDate ?? DateRangeUtils.getTodayString(),
    );

    final today = DateRangeUtils.getTodayString();
    final yesterday = DateRangeUtils.getYesterdayString();
    final last7 = DateRangeUtils.getLast7DaysString();
    final monthStart = DateRangeUtils.getStartOfMonthString();
    final monthEnd = DateRangeUtils.getEndOfMonthString();

    final currentFrom = DateRangeUtils.cleanDate(component.fromDate);
    final currentTo = DateRangeUtils.cleanDate(component.toDate);

    final buttonLabel = DateRangeUtils.computeButtonLabel(
      fromDate: component.fromDate,
      toDate: component.toDate,
    );

    return details(
      classes: 'dropdown dropdown-bottom dropdown-start w-full sm:w-auto inline-block',
      [
        summary(
          classes: 'btn btn-sm rounded-xl sm:rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3.5 font-medium flex items-center justify-between sm:justify-start gap-2 shadow-2xs cursor-pointer list-none select-none w-full sm:w-auto h-9',
          [
            div(classes: 'flex items-center gap-2 truncate', [
              Calendar(classes: 'w-3.5 h-3.5 text-primary shrink-0'),
              span(classes: 'text-xs text-base-content font-medium truncate', [
                .text(buttonLabel),
              ]),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60 shrink-0'),
          ],
        ),
        div(
          classes: 'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-3 shadow-xl border border-border-medium w-80 max-w-[calc(100vw-2.5rem)] flex flex-col gap-2.5',
          [
            DatePickerPresetButtons(
              isToday: currentFrom == today && currentTo == today,
              isYesterday: currentFrom == yesterday && currentTo == yesterday,
              isLast7: currentFrom == last7 && currentTo == today,
              isThisMonth: currentFrom == monthStart && currentTo == monthEnd,
              isAllTime: currentFrom.isEmpty && currentTo.isEmpty,
              today: today,
              yesterday: yesterday,
              last7: last7,
              monthStart: monthStart,
              monthEnd: monthEnd,
              onSelectRange: _applyRange,
            ),
            CustomDateRangeInputs(
              tempFrom: _tempFrom,
              tempTo: _tempTo,
              onFromChanged: (val) => _tempFrom = DateRangeUtils.cleanDate(val),
              onToChanged: (val) => _tempTo = DateRangeUtils.cleanDate(val),
            ),
            div(
              classes: 'flex justify-between items-center mt-0.5 border-t border-border-light pt-2',
              [
                button(
                  classes: 'btn btn-xs btn-ghost text-error rounded-full font-medium',
                  onClick: () => _applyRange(today, today),
                  [.text('Reset to Today')],
                ),
                button(
                  classes: 'btn btn-xs btn-primary rounded-full px-4 text-white font-medium',
                  onClick: () => _applyRange(_tempFrom, _tempTo),
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
