import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/circle_dollar_sign.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:merchant/components/containers/bottle_return_reward_editor.dart';

export 'package:merchant/components/containers/bottle_return_reward_editor.dart';

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
    if (_isEditing) {
      return BottleReturnRewardEditor(
        amount: _amount,
        onAmountChanged: (val) => setState(() => _amount = val),
        onCancel: () => setState(() => _isEditing = false),
        onSave: _save,
      );
    }

    return div(
      classes:
          'flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-3 sm:p-3.5 bg-neutral/30 border border-border-medium/60 rounded-xl',
      [
        div(classes: 'flex items-center gap-2.5 sm:gap-3 min-w-0 flex-1', [
          div(
            classes:
                'w-9 h-9 rounded-lg bg-amber-500/10 flex items-center justify-center text-amber-600 shrink-0',
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
          classes:
              'flex items-center justify-center gap-1.5 h-9 px-3.5 bg-white hover:bg-neutral border border-border-medium/70 rounded-lg text-xs font-semibold text-primary cursor-pointer transition-colors shadow-2xs w-full sm:w-auto shrink-0',
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
}
