import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

/// Toggle checkbox field controlling store active status.
class StoreActiveToggleField extends StatelessComponent {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const StoreActiveToggleField({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'form-control mb-4 flex flex-row items-center gap-3', [
      p(classes: 'text-[14px] font-semibold text-gray-500', [
        .text('Active'),
      ]),
      input(
        type: InputType.checkbox,
        classes:
            'toggle ${isActive ? 'toggle-success' : ''} hover:cursor-pointer',
        checked: isActive,
        events: {
          'change': (e) =>
              onChanged((e.target as web.HTMLInputElement).checked),
        },
      ),
    ]);
  }
}
