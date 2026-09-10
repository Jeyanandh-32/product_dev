import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/circle_dollar_sign.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:web/web.dart' as web;

/// Configuration card allowing merchants to view and update bottle return reward amounts.
class BottleReturnRewardCard extends StatefulComponent {
  const BottleReturnRewardCard({
    super.key,
    required this.rewardAmount,
    required this.onSaveReward,
  });

  final int rewardAmount;
  final ValueChanged<int> onSaveReward;

  @override
  State<BottleReturnRewardCard> createState() => _BottleReturnRewardCardState();
}

class _BottleReturnRewardCardState extends State<BottleReturnRewardCard> {
  bool _isEditing = false;
  int _amount = 0;

  @override
  void initState() {
    super.initState();
    _amount = component.rewardAmount;
  }

  void _save() {
    if (_amount > 0) {
      component.onSaveReward(_amount);
      setState(() => _isEditing = false);
    }
  }

  @override
  Component build(BuildContext context) {
    if (!_isEditing) {
      return div(
        classes: 'flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-3 sm:p-3.5 bg-neutral/30 border border-border-medium/60 rounded-xl',
        [
          div(classes: 'flex items-center gap-2.5 sm:gap-3 min-w-0 flex-1', [
            div(
              classes: 'w-9 h-9 rounded-lg bg-amber-500/10 flex items-center justify-center text-amber-600 shrink-0',
              [CircleDollarSign(classes: 'w-4.5 h-4.5')],
            ),
            div(classes: 'flex flex-col min-w-0 flex-1', [
              span(classes: 'text-xs font-semibold text-gray-500', [
                .text('Deposit Reward Value'),
              ]),
              span(
                classes: 'text-xs sm:text-sm font-bold text-primary truncate',
                [
                  .text(
                    '₹${component.rewardAmount} credited per bottle return',
                  ),
                ],
              ),
            ]),
          ]),
          button(
            classes: 'flex items-center justify-center gap-1.5 h-9 px-3.5 bg-white hover:bg-neutral border border-border-medium/70 rounded-lg text-xs font-semibold text-primary cursor-pointer transition-colors shadow-2xs w-full sm:w-auto shrink-0',
            onClick: () {
              setState(() {
                _amount = component.rewardAmount;
                _isEditing = true;
              });
            },
            [
              SquarePen(classes: 'w-3.5 h-3.5 text-gray-500'),
              .text('Change Reward'),
            ],
          ),
        ],
      );
    }

    return div(
      classes: 'flex flex-col gap-3 p-3 sm:p-4 bg-neutral/30 border border-border-medium/70 rounded-xl transition-all',
      [
        div(
          classes:
              'flex flex-col sm:flex-row sm:items-center justify-between gap-1',
          [
            span(
              classes: 'text-xs font-bold text-primary uppercase tracking-wide',
              [
                .text('Set Bottle Deposit Reward'),
              ],
            ),
            span(classes: 'text-[11px] sm:text-xs text-gray-500', [
              .text('Applied to customer wallet on return'),
            ]),
          ],
        ),
        div(
          classes: 'flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1',
          [
            div(classes: 'flex flex-wrap items-center gap-1.5 sm:gap-2', [
              for (final preset in [5, 10, 15, 20])
                button(
                  classes: _presetBtnClasses(_amount == preset),
                  onClick: () => setState(() => _amount = preset),
                  [.text('₹$preset')],
                ),
              div(classes: 'relative', [
                span(
                  classes: 'absolute inset-y-0 left-0 pl-2.5 flex items-center text-xs font-bold text-gray-500 pointer-events-none',
                  [.text('₹')],
                ),
                input(
                  type: InputType.number,
                  classes: 'input input-sm w-20 h-8 sm:h-9 pl-6 text-sm font-bold text-primary border border-border-medium rounded-lg focus:border-accent focus:outline-none',
                  value: '$_amount',
                  events: {
                    'input': (e) {
                      final target = e.target as web.HTMLInputElement;
                      final v = int.tryParse(target.value);
                      if (v != null && v > 0) setState(() => _amount = v);
                    },
                  },
                ),
              ]),
            ]),
            div(
              classes: 'flex items-center justify-end gap-2 w-full sm:w-auto',
              [
                button(
                  classes: 'flex-1 sm:flex-none h-8 sm:h-9 px-3 sm:px-4 text-xs sm:text-sm font-semibold text-gray-500 hover:text-gray-800 hover:bg-neutral/60 rounded-lg cursor-pointer transition-colors text-center',
                  onClick: () => setState(() => _isEditing = false),
                  [.text('Cancel')],
                ),
                button(
                  classes: 'flex-1 sm:flex-none h-8 sm:h-9 px-3.5 sm:px-5 text-xs sm:text-sm font-semibold bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg cursor-pointer transition-colors shadow-sm text-center',
                  onClick: _save,
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
