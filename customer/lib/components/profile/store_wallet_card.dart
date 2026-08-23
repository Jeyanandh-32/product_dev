import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

/// Store Wallet / Bottle Return Rewards Card displayed on customer profile.
class StoreWalletCard extends StatelessComponent {
  final Store? currentStore;
  final String? storeId;
  final double walletBalance;
  final VoidCallback onAddMoney;
  final VoidCallback onViewTransactions;

  const StoreWalletCard({
    super.key,
    required this.currentStore,
    required this.storeId,
    required this.walletBalance,
    required this.onAddMoney,
    required this.onViewTransactions,
  });

  @override
  Component build(BuildContext context) {
    final isBottleStore = currentStore?.isBottleReturnEnabled == true ||
        currentStore?.storeType?.toLowerCase() == 'liquor';

    final title = isBottleStore ? 'Bottle Return Rewards' : 'Store Wallet';
    final subtitle = isBottleStore
        ? 'Earned credits available for order discounts'
        : 'Available prepaid balance for store orders';
    final historyBtnLabel = isBottleStore ? 'Reward History' : 'Transactions';

    return div(
      classes:
          'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col gap-6',
      [
        div(
          classes:
              'flex items-center justify-between border-b border-gray-100 pb-4',
          [
            div(classes: 'flex items-center gap-2.5', [
              if (isBottleStore)
                Sparkles(classes: 'w-5 h-5 text-emerald-600')
              else
                Wallet(classes: 'w-5 h-5 text-emerald-600'),
              h3(classes: 'text-base font-extrabold text-black', [
                .text(title),
              ]),
            ]),
            if (currentStore != null)
              span(
                classes:
                    'text-xs font-bold px-3 py-1 rounded-full border bg-emerald-50 text-emerald-700 border-emerald-200',
                [.text(currentStore!.name)],
              ),
          ],
        ),

        if (storeId != null)
          div(
            classes:
                'flex flex-col sm:flex-row sm:items-center justify-between gap-4 pt-1',
            [
              div(classes: 'flex flex-col gap-1', [
                div(classes: 'flex items-baseline gap-1', [
                  span(
                    classes: 'text-lg font-bold text-emerald-600',
                    [.text('₹')],
                  ),
                  span(
                    classes:
                        'text-2xl sm:text-3xl font-extrabold text-black tracking-tight',
                    [
                      .text(walletBalance.toStringAsFixed(2)),
                    ],
                  ),
                ]),
                span(classes: 'text-xs text-gray-500 font-medium', [
                  .text(subtitle),
                ]),
              ]),

              div(classes: 'flex items-center gap-2.5', [
                if (!isBottleStore)
                  button(
                    classes:
                        'flex-1 sm:flex-none justify-center flex items-center gap-1.5 px-4 py-2.5 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs transition-all border-0 cursor-pointer active:scale-95 shadow-xs',
                    onClick: onAddMoney,
                    [
                      Plus(classes: 'w-4 h-4 text-white'),
                      .text('Add Money'),
                    ],
                  ),
                button(
                  classes:
                      'flex-1 sm:flex-none justify-center flex items-center gap-1.5 px-4 py-2.5 rounded-2xl bg-black hover:bg-gray-800 text-white font-bold text-xs transition-all border-0 cursor-pointer active:scale-95 shadow-xs',
                  onClick: onViewTransactions,
                  [
                    History(classes: 'w-4 h-4 text-white'),
                    .text(historyBtnLabel),
                  ],
                ),
              ]),
            ],
          )
        else
          div(
            classes:
                'flex flex-col items-center justify-center py-6 text-center gap-3',
            [
              div(
                classes:
                    'w-12 h-12 rounded-2xl bg-gray-50 flex items-center justify-center text-gray-400',
                [Building2(classes: 'w-6 h-6')],
              ),
              div(classes: 'flex flex-col gap-1', [
                p(
                  classes: 'text-sm font-extrabold text-black',
                  [.text('No Store Selected')],
                ),
                p(classes: 'text-xs text-gray-500 max-w-sm', [
                  .text(
                    'Select a store to view your store wallet and reward balances.',
                  ),
                ]),
              ]),
              a(
                href: '/',
                classes:
                    'mt-2 inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-black text-white font-bold text-xs hover:bg-gray-800 transition-all no-underline',
                [
                  ShoppingBag(classes: 'w-3.5 h-3.5 text-white'),
                  .text('Explore Stores'),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
