import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;

class CartSummaryCard extends StatelessComponent {
  final int totalItemCount;
  final int totalQuantity;
  final double subtotal;
  final double totalTax;
  final double grandTotal;
  final bool isLoggedIn;
  final double walletBalance;
  final bool useWallet;
  final bool isSubmitting;
  final VoidCallback onToggleWallet;
  final VoidCallback onCheckout;

  const CartSummaryCard({
    super.key,
    required this.totalItemCount,
    required this.totalQuantity,
    required this.subtotal,
    required this.totalTax,
    required this.grandTotal,
    required this.isLoggedIn,
    required this.walletBalance,
    required this.useWallet,
    required this.isSubmitting,
    required this.onToggleWallet,
    required this.onCheckout,
  });

  @override
  Component build(BuildContext context) {
    final hasBalance = walletBalance > 0;
    final walletDeduction = useWallet && hasBalance
        ? (walletBalance >= grandTotal ? grandTotal : walletBalance)
        : 0.0;
    final finalPayable = grandTotal - walletDeduction;

    return div(
      classes:
          'bg-white rounded-3xl p-6 border border-gray-200/80 shadow-sm flex flex-col gap-6 sticky top-24',
      [
        h2(
          classes:
              'text-lg font-extrabold text-black tracking-tight border-b border-gray-100 pb-4',
          [
            .text('Order Summary'),
          ],
        ),

        div(classes: 'flex flex-col gap-3 text-sm', [
          div(classes: 'flex justify-between items-center text-gray-500', [
            span([.text('Total No of Items')]),
            span(classes: 'font-semibold text-black', [
              .text('$totalItemCount'),
            ]),
          ]),
          div(classes: 'flex justify-between items-center text-gray-500', [
            span([.text('Total Order Quantity')]),
            span(classes: 'font-semibold text-black', [
              .text('$totalQuantity'),
            ]),
          ]),
          div(classes: 'flex justify-between items-center text-gray-500', [
            span([.text('Order Summary')]),
            span(classes: 'font-semibold text-black', [
              .text('₹${subtotal.toStringAsFixed(2)}'),
            ]),
          ]),
          div(classes: 'flex justify-between items-center text-gray-500', [
            span([.text('Gateway Charges')]),
            span(classes: 'font-semibold text-emerald-600', [
              .text('₹0.00 (Free)'),
            ]),
          ]),
          div(classes: 'flex justify-between items-center text-gray-500', [
            span([.text('Total Tax')]),
            span(classes: 'font-semibold text-black', [
              .text('₹${totalTax.toStringAsFixed(2)}'),
            ]),
          ]),

          if (isLoggedIn) ...[
            div(
              classes: 'flex flex-col gap-2.5 pt-2 border-t border-gray-100',
              [
                div(
                  classes:
                      'flex items-center justify-between p-3 rounded-2xl border transition-all select-none ${hasBalance ? 'bg-gray-50 border-gray-200/80 cursor-pointer hover:bg-gray-100/80 active:scale-99' : 'bg-gray-50/50 border-gray-200/50 opacity-60 cursor-not-allowed'}',
                  events: {
                    if (hasBalance) 'click': (_) => onToggleWallet(),
                  },
                  [
                    div(classes: 'flex items-center gap-2.5', [
                      Wallet(
                        classes:
                            'w-4 h-4 ${hasBalance ? 'text-emerald-600' : 'text-gray-400'}',
                      ),
                      div(classes: 'flex flex-col', [
                        span(
                          classes: 'text-xs font-bold text-black',
                          [.text('Wallet')],
                        ),
                        span(
                          classes: 'text-[11px] font-semibold text-gray-400',
                          [
                            .text(
                              'Available: ₹${walletBalance.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ]),
                    ]),
                    div(
                      classes:
                          'w-4 h-4 rounded-full border flex items-center justify-center transition-all ${useWallet && hasBalance ? 'border-emerald-600 bg-emerald-600' : 'border-gray-300 bg-white'}',
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
                      span([.text('Wallet Deduction')]),
                      span(classes: 'font-extrabold text-emerald-600', [
                        .text('-₹${walletDeduction.toStringAsFixed(2)}'),
                      ]),
                    ],
                  ),
                div(
                  classes:
                      'border-t border-dashed border-gray-200 pt-3 mt-1 flex justify-between items-center text-base font-extrabold text-black',
                  [
                    span([.text('To Pay')]),
                    span(classes: 'text-emerald-700', [
                      .text('₹${finalPayable.toStringAsFixed(2)}'),
                    ]),
                  ],
                ),
              ],
            ),
          ] else
            div(
              classes:
                  'border-t border-dashed border-gray-200 pt-3 mt-1 flex justify-between items-center text-base font-extrabold text-black',
              [
                span([.text('Total Amount')]),
                span([.text('₹${grandTotal.toStringAsFixed(2)}')]),
              ],
            ),
        ]),

        button(
          classes:
              'w-full py-4 rounded-2xl bg-black hover:bg-gray-800 text-white font-bold text-sm flex items-center justify-center gap-2 cursor-pointer transition-all shadow-sm border-0 active:scale-98',
          onClick: onCheckout,
          [
            if (isSubmitting)
              span(classes: 'loading loading-spinner loading-sm', [])
            else if (!isLoggedIn) ...[
              .text('Sign In to Place Order'),
              ArrowRight(classes: 'w-4 h-4'),
            ] else ...[
              .text('Place Order Now'),
              ArrowRight(classes: 'w-4 h-4'),
            ],
          ],
        ),
      ],
    );
  }
}
