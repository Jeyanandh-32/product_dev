import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

/// Form inputs for changing and confirming customer security PIN.
class SecurityPinInputs extends StatelessComponent {
  final ValueChanged<String> onCurrentPinChanged;
  final ValueChanged<String> onNewPinChanged;
  final ValueChanged<String> onConfirmPinChanged;

  const SecurityPinInputs({
    super.key,
    required this.onCurrentPinChanged,
    required this.onNewPinChanged,
    required this.onConfirmPinChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-4', [
      div(classes: 'flex flex-col gap-1.5', [
        label(
          classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider',
          [
            .text('Current Security PIN'),
          ],
        ),
        input(
          type: InputType.password,
          classes:
              'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
          attributes: {'placeholder': '••••••', 'maxlength': '6'},
          events: {
            'input': (e) {
              final el = e.target as web.HTMLInputElement;
              onCurrentPinChanged(el.value);
            },
          },
        ),
      ]),

      div(classes: 'grid grid-cols-1 sm:grid-cols-2 gap-4', [
        div(classes: 'flex flex-col gap-1.5', [
          label(
            classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider',
            [
              .text('New 6-Digit PIN'),
            ],
          ),
          input(
            type: InputType.password,
            classes:
                'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
            attributes: {'placeholder': '••••••', 'maxlength': '6'},
            events: {
              'input': (e) {
                final el = e.target as web.HTMLInputElement;
                onNewPinChanged(el.value);
              },
            },
          ),
        ]),

        div(classes: 'flex flex-col gap-1.5', [
          label(
            classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider',
            [
              .text('Confirm New PIN'),
            ],
          ),
          input(
            type: InputType.password,
            classes:
                'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
            attributes: {'placeholder': '••••••', 'maxlength': '6'},
            events: {
              'input': (e) {
                final el = e.target as web.HTMLInputElement;
                onConfirmPinChanged(el.value);
              },
            },
          ),
        ]),
      ]),
    ]);
  }
}
