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
      classes: 'flex items-center justify-between p-3 sm:p-4 bg-neutral/40 border border-border-medium/70 rounded-xl gap-2.5 sm:gap-3',
      [
        div(classes: 'flex items-center gap-2.5 sm:gap-3 min-w-0 flex-1', [
          div(
            classes: 'w-9 h-9 sm:w-10 sm:h-10 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-600 shrink-0',
            [Recycle(classes: 'w-4.5 h-4.5 sm:w-5 sm:h-5')],
          ),
          div(classes: 'flex flex-col min-w-0 flex-1', [
            div(classes: 'flex flex-wrap items-center gap-1.5 sm:gap-2', [
              h4(classes: 'font-semibold text-primary text-xs sm:text-sm', [
                .text('Deposit & Return Program'),
              ]),
              span(
                classes: isEnabled
                    ? 'bg-soft-green text-soft-green-content text-[10px] sm:text-[11px] font-semibold px-1.5 sm:px-2 py-0.5 rounded-full flex items-center gap-1 shrink-0'
                    : 'bg-soft-red text-soft-red-content text-[10px] sm:text-[11px] font-semibold px-1.5 sm:px-2 py-0.5 rounded-full shrink-0',
                [
                  if (isEnabled)
                    span(
                      classes: 'w-1.5 h-1.5 rounded-full bg-emerald-600',
                      [],
                    ),
                  .text(isEnabled ? 'Active' : 'Disabled'),
                ],
              ),
            ]),
            p(
              classes: 'text-[11px] sm:text-xs text-gray-500 mt-0.5 line-clamp-2 sm:line-clamp-none',
              [
                .text('Manage deposit tokens and returnable beverage bottles.'),
              ],
            ),
          ]),
        ]),

        input(
          type: InputType.checkbox,
          classes:
              'toggle toggle-sm ${isEnabled ? 'toggle-success' : ''} hover:cursor-pointer shrink-0',
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
