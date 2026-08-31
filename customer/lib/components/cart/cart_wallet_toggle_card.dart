import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store;
import 'package:models/models.dart';

/// Interactive toggle card allowing customers to apply store wallet or bottle return reward balance.
class CartWalletToggleCard extends StatelessComponent {
  final Store? currentStore;
  final double walletBalance;
  final bool useWallet;
  final double walletDeduction;
  final double finalPayable;
  final VoidCallback onToggleWallet;

  const CartWalletToggleCard({
    super.key,
    this.currentStore,
    required this.walletBalance,
    required this.useWallet,
    required this.walletDeduction,
    required this.finalPayable,
    required this.onToggleWallet,
  });

  @override
  Component build(BuildContext context) {
    final isBottleStore = currentStore?.isBottleReturnEnabled == true;
    final hasBalance = walletBalance > 0;
    final title = isBottleStore ? 'Bottle Return Rewards' : 'Store Wallet';
    final deductionLabel = isBottleStore
        ? 'Reward Deduction'
        : 'Wallet Deduction';

    final containerStateClasses = hasBalance
        ? 'bg-gray-50 border-gray-200/80 cursor-pointer hover:bg-gray-100/80 active:scale-99'
        : 'bg-gray-50/50 border-gray-200/50 opacity-60 cursor-not-allowed';

    final indicatorClasses = useWallet && hasBalance
        ? 'border-emerald-600 bg-emerald-600'
        : 'border-gray-300 bg-white';

    return div(
      classes: 'flex flex-col gap-2.5 pt-2 border-t border-gray-100',
      [
        div(
          classes:
              'flex items-center justify-between p-3 rounded-2xl border transition-all select-none $containerStateClasses',
          events: {
            if (hasBalance) 'click': (_) => onToggleWallet(),
          },
          [
            div(classes: 'flex items-center gap-2.5', [
              if (isBottleStore)
                Sparkles(
                  classes:
                      'w-4 h-4 ${hasBalance ? 'text-emerald-600' : 'text-gray-400'}',
                )
              else
                Wallet(
                  classes:
                      'w-4 h-4 ${hasBalance ? 'text-emerald-600' : 'text-gray-400'}',
                ),
              div(classes: 'flex flex-col', [
                span(
                  classes: 'text-xs font-bold text-black',
                  [.text(title)],
                ),
                span(
                  classes: 'text-[11px] font-semibold text-gray-400',
                  [
                    .text('Available: ₹${walletBalance.toStringAsFixed(2)}'),
                  ],
                ),
              ]),
            ]),
            div(
              classes:
                  'w-4 h-4 rounded-full border flex items-center justify-center transition-all $indicatorClasses',
              [
                if (useWallet && hasBalance)
                  div(classes: 'w-1.5 h-1.5 rounded-full bg-white', []),
              ],
            ),
          ],
        ),
        if (walletDeduction > 0)
          div(
            classes:
                'flex justify-between items-center text-gray-500 text-xs px-1',
            [
              span([.text(deductionLabel)]),
              span(classes: 'font-extrabold text-emerald-600', [
                .text('-₹${walletDeduction.toStringAsFixed(2)}'),
              ]),
            ],
          ),
        div(
          classes: 'border-t border-dashed border-gray-200 pt-3 mt-1 flex justify-between items-center text-base font-extrabold text-black',
          [
            span([.text('To Pay')]),
            span(classes: 'text-emerald-700', [
              .text('₹${finalPayable.toStringAsFixed(2)}'),
            ]),
          ],
        ),
      ],
    );
  }
}
