import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/recycle.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

class BottleReturnHeader extends StatelessComponent {
  const BottleReturnHeader({
    super.key,
    required this.store,
    required this.isEnabled,
    required this.returnableCount,
    required this.onToggleStore,
  });

  final Store store;
  final bool isEnabled;
  final int returnableCount;
  final ValueChanged<bool> onToggleStore;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex justify-between items-center p-4 bg-neutral/40 border border-border-medium/70 rounded-xl',
      [
        div(classes: 'flex items-center gap-3', [
          div(
            classes:
                'w-10 h-10 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-600 shrink-0',
            [Recycle(classes: 'w-5 h-5')],
          ),
          div(classes: 'flex flex-col', [
            div(classes: 'flex items-center gap-2', [
              h4(classes: 'font-semibold text-primary text-sm', [
                .text('Deposit & Return Program'),
              ]),
              span(
                classes: isEnabled
                    ? 'bg-soft-green text-soft-green-content text-[11px] font-semibold px-2 py-0.5 rounded-full flex items-center gap-1'
                    : 'bg-soft-red text-soft-red-content text-[11px] font-semibold px-2 py-0.5 rounded-full',
                [
                  if (isEnabled)
                    span(classes: 'w-1.5 h-1.5 rounded-full bg-emerald-600', []),
                  .text(isEnabled ? 'Active' : 'Disabled'),
                ],
              ),
            ]),
            p(classes: 'text-xs text-gray-500 mt-0.5', [
              .text('Manage deposit tokens and returnable beverage bottles.'),
            ]),
          ]),
        ]),

        input(
          type: InputType.checkbox,
          classes:
              'toggle toggle-sm ${isEnabled ? 'toggle-success' : ''} hover:cursor-pointer',
          checked: isEnabled,
          events: {
            'change': (e) {
              final target = e.target as web.HTMLInputElement;
              onToggleStore(target.checked);
            },
          },
        ),
      ],
    );
  }
}
