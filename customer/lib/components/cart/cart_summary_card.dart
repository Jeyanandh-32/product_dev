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
  final double platformFee;
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
    this.platformFee = 0.0,
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

    final isStoreOrderingActive = switch (currentStore) {
      final store? => store.isOperational && store.isOnlineEnabled,
      _ => true,
    };

    final buttonClasses = isStoreOrderingActive
        ? 'w-full py-4 rounded-2xl bg-[#0B132B] hover:bg-[#1C2541] text-white font-bold text-sm flex items-center justify-center gap-2 cursor-pointer transition-all shadow-[0_4px_14px_rgba(11,19,43,0.22)] active:scale-98 border-0'
        : 'w-full py-4 rounded-2xl bg-slate-200 text-slate-400 font-bold text-sm flex items-center justify-center gap-2 cursor-not-allowed border border-transparent shadow-none';

    return div(
      classes: 'lg:col-span-5 w-full bg-white rounded-3xl p-6 sm:p-7 border border-border-medium shadow-xs flex flex-col gap-6 sticky top-24',
      [
        h2(
          classes: 'text-lg font-extrabold text-slate-900 tracking-tight border-b border-border-light pb-4',
          [.text('Order Summary')],
        ),

        div(classes: 'flex flex-col gap-3 text-sm', [
          div(classes: 'flex justify-between items-center text-slate-500', [
            span([.text('Total No of Items')]),
            span(classes: 'font-semibold text-slate-900', [
              .text('$totalItemCount'),
            ]),
          ]),
          div(classes: 'flex justify-between items-center text-slate-500', [
            span([.text('Total Order Quantity')]),
            span(classes: 'font-semibold text-slate-900', [
              .text('$totalQuantity'),
            ]),
          ]),
          div(classes: 'flex justify-between items-center text-slate-500', [
            span([.text('Items Subtotal')]),
            span(classes: 'font-semibold text-slate-900', [
              .text('₹${subtotal.toStringAsFixed(2)}'),
            ]),
          ]),
          if (totalTax > 0)
            div(classes: 'flex justify-between items-center text-slate-500', [
              span([.text('Taxes & Charges')]),
              span(classes: 'font-semibold text-slate-900', [
                .text('₹${totalTax.toStringAsFixed(2)}'),
              ]),
            ]),
          if (platformFee > 0)
            div(classes: 'flex justify-between items-center text-slate-500', [
              span([.text('Platform Fee (1.99%)')]),
              span(classes: 'font-semibold text-slate-900', [
                .text('₹${platformFee.toStringAsFixed(2)}'),
              ]),
            ]),
          div(classes: 'flex justify-between items-center text-slate-500', [
            span([.text('Gateway Charges (PhonePe)')]),
            span(classes: 'font-semibold text-emerald-600', [
              .text('Free (₹0.00)'),
            ]),
          ]),
          div(
            classes: 'border-t border-dashed border-border-medium pt-2 flex justify-between items-center text-sm font-bold text-slate-900',
            [
              span([.text('Order Total')]),
              span([.text('₹${grandTotal.toStringAsFixed(2)}')]),
            ],
          ),

          if (isLoggedIn)
            CartWalletToggleCard(
              currentStore: currentStore,
              walletBalance: walletBalance,
              useWallet: useWallet,
              walletDeduction: walletDeduction,
              finalPayable: finalPayable,
              onToggleWallet: onToggleWallet,
            ),
        ]),

        button(
          classes: buttonClasses,
          disabled: !isStoreOrderingActive || isSubmitting,
          onClick: isStoreOrderingActive ? onCheckout : null,
          [
            if (isSubmitting)
              span(classes: 'loading loading-spinner loading-sm', [])
            else if (!isStoreOrderingActive)
              .text('Online Ordering Paused')
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
