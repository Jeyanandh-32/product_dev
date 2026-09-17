import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

/// Editor view for configuring bottle deposit reward amount.
class BottleReturnRewardEditor extends StatelessComponent {
  const BottleReturnRewardEditor({
    super.key,
    required this.amount,
    required this.onAmountChanged,
    required this.onCancel,
    required this.onSave,
  });

  final int amount;
  final ValueChanged<int> onAmountChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col gap-3 p-3 sm:p-4 bg-neutral/30 border border-border-medium/70 rounded-xl transition-all',
      [
        div(
          classes:
              'flex flex-col sm:flex-row sm:items-center justify-between gap-1',
          [
            span(
              classes:
                  'text-xs font-bold text-primary uppercase tracking-wide',
              [.text('Set Bottle Deposit Reward')],
            ),
            span(classes: 'text-[11px] sm:text-xs text-gray-500', [
              .text('Applied to customer wallet on return'),
            ]),
          ],
        ),
        div(
          classes:
              'flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1',
          [
            div(classes: 'flex flex-wrap items-center gap-1.5 sm:gap-2', [
              for (final preset in [5, 10, 15, 20])
                button(
                  classes: _presetBtnClasses(amount == preset),
                  onClick: () => onAmountChanged(preset),
                  [.text('₹$preset')],
                ),
              div(classes: 'relative', [
                span(
                  classes:
                      'absolute inset-y-0 left-0 pl-2.5 flex items-center text-xs font-bold text-gray-500 pointer-events-none',
                  [.text('₹')],
                ),
                input(
                  type: InputType.number,
                  classes:
                      'input input-sm w-20 h-8 sm:h-9 pl-6 text-sm font-bold text-primary border border-border-medium rounded-lg focus:border-accent focus:outline-none',
                  value: '$amount',
                  events: {
                    'input': (e) {
                      final target = e.target as web.HTMLInputElement;
                      final v = int.tryParse(target.value);
                      if (v != null && v > 0) onAmountChanged(v);
                    },
                  },
                ),
              ]),
            ]),
            div(
              classes:
                  'flex items-center justify-end gap-2 w-full sm:w-auto',
              [
                button(
                  classes:
                      'flex-1 sm:flex-none h-8 sm:h-9 px-3 sm:px-4 text-xs sm:text-sm font-semibold text-gray-500 hover:text-gray-800 hover:bg-neutral/60 rounded-lg cursor-pointer transition-colors text-center',
                  onClick: onCancel,
                  [.text('Cancel')],
                ),
                button(
                  classes:
                      'flex-1 sm:flex-none h-8 sm:h-9 px-3.5 sm:px-5 text-xs sm:text-sm font-semibold bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg cursor-pointer transition-colors shadow-sm text-center',
                  onClick: onSave,
                  [.text('Save Reward')],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _presetBtnClasses(bool isSelected) =>
      'h-8 sm:h-9 px-2.5 sm:px-3 text-xs sm:text-sm font-semibold rounded-lg border transition-all cursor-pointer ${isSelected ? 'bg-primary text-primary-content border-primary shadow-xs' : 'bg-white text-gray-700 border-border-medium hover:bg-neutral/60'}';
}
