import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Form input inputs for custom Start and End date range selection.
class CustomDateRangeInputs extends StatelessComponent {
  final String tempFrom;
  final String tempTo;
  final ValueChanged<String> onFromChanged;
  final ValueChanged<String> onToChanged;

  const CustomDateRangeInputs({
    super.key,
    required this.tempFrom,
    required this.tempTo,
    required this.onFromChanged,
    required this.onToChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-1 pt-1 border-t border-border-light', [
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
            value: tempFrom,
            classes:
                'input input-sm border border-border-medium bg-base-100 rounded-lg text-xs w-full focus:outline-none focus:border-primary',
            onInput: (value) => onFromChanged(value.toString().trim()),
          ),
        ]),
        div(classes: 'flex flex-col gap-0.5', [
          label(classes: 'text-2xs font-medium text-gray-600 px-1', [
            .text('To Date'),
          ]),
          input(
            type: InputType.date,
            value: tempTo,
            classes:
                'input input-sm border border-border-medium bg-base-100 rounded-lg text-xs w-full focus:outline-none focus:border-primary',
            onInput: (value) => onToChanged(value.toString().trim()),
          ),
        ]),
      ]),
    ]);
  }
}
