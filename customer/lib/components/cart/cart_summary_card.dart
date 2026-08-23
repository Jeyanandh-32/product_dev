import 'package:customer/components/cart/cart_wallet_toggle_card.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store;
import 'package:models/models.dart';

/// Cart financial summary card and checkout action button.
class CartSummaryCard extends StatelessComponent {
  final Store? currentStore;
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
    this.currentStore,
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

          if (isLoggedIn)
            CartWalletToggleCard(
              currentStore: currentStore,
              walletBalance: walletBalance,
              useWallet: useWallet,
              walletDeduction: walletDeduction,
              finalPayable: finalPayable,
              onToggleWallet: onToggleWallet,
            )
          else
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
