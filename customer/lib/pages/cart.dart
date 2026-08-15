import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/cart/cart_item_card.dart';
import 'package:customer/components/cart/cart_summary_card.dart';
import 'package:customer/components/cart/empty_cart_state.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/utils/cart_checkout_handler.dart';
import 'package:customer/utils/customer_navigation.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';

/// Customer shopping cart review and checkout screen.
class CartPage extends SignalComponent {
  const CartPage({super.key});

  @override
  SignalState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends SignalState<CartPage> {
  bool _isSubmitting = false;
  bool _useWallet = true;
  double _storeWalletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchStoreWalletBalance();
  }

  Future<void> _fetchStoreWalletBalance() async {
    final customer = customerAuthSignal.value.value;
    if (customer == null) return;

    final storeId = currentCartStoreIdSignal.value;
    if (storeId == null) return;
    try {
      final info = await CustomerWalletRepository.getWalletInfo(
        storeId: storeId,
      );
      if (mounted) {
        setState(() => _storeWalletBalance = info.balance);
      }
    } catch (_) {}
  }

  Future<void> _checkoutOrder() async {
    await CartCheckoutHandler.initiateCheckout(
      context: context,
      useWallet: _useWallet,
      setSubmitting: (val) {
        if (mounted) setState(() => _isSubmitting = val);
      },
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final items = cartItemsSignal.value.values.toList();
    final currentStore = currentCartStoreSignal.value;

    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + ((item.product.sellingPrice * item.quantity) / 100.0),
    );
    final totalTax = items.fold<double>(
      0.0,
      (sum, item) {
        final taxRate = item.product.taxRate;
        final itemPrice = (item.product.sellingPrice * item.quantity) / 100.0;
        return sum + (itemPrice * (taxRate / 100.0));
      },
    );
    final grandTotal = subtotal + totalTax;
    final totalQuantity = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return div(
      classes: 'max-w-4xl mx-auto w-full flex flex-col gap-8',
      [
        div(
          classes:
              'flex items-center justify-between border-b border-gray-100 pb-6',
          [
            div(classes: 'flex items-center gap-4', [
              button(
                classes:
                    'w-10 h-10 rounded-full bg-gray-100 hover:bg-black hover:text-white text-black transition-all flex items-center justify-center cursor-pointer border-0',
                onClick: () => navigateToRecentStoreOrAll(context),
                [
                  ArrowLeft(classes: 'w-5 h-5'),
                ],
              ),
              div(classes: 'flex flex-col', [
                h1(
                  classes:
                      'text-xl md:text-3xl font-extrabold text-black tracking-tight',
                  [
                    .text('Your Shopping Cart'),
                  ],
                ),
                if (currentStore != null)
                  span(classes: 'text-xs font-bold text-gray-400', [
                    .text('Ordering from ${currentStore.name}'),
                  ]),
              ]),
            ]),

            if (items.isNotEmpty)
              button(
                classes:
                    'px-3.5 py-1.5 rounded-full bg-red-50 hover:bg-red-600 text-red-600 hover:text-white font-extrabold text-xs flex items-center gap-1.5 transition-all cursor-pointer border border-red-200/80 shadow-2xs active:scale-95 shrink-0',
                onClick: clearCart,
                [
                  Trash2(classes: 'w-3.5 h-3.5'),
                  .text('Clear Cart'),
                ],
              ),
          ],
        ),

        if (items.isEmpty)
          EmptyCartState(
            currentStore: currentStore,
            onExplore: () {
              if (currentStore?.slug != null) {
                Router.of(context).push('/store/${currentStore!.slug!}');
              } else {
                Router.of(context).push('/');
              }
            },
          )
        else
          div(classes: 'grid grid-cols-1 lg:grid-cols-3 gap-8 items-start', [
            div(classes: 'lg:col-span-2 flex flex-col gap-4', [
              for (final item in items) CartItemCard(item: item),
            ]),

            CartSummaryCard(
              totalItemCount: items.length,
              totalQuantity: totalQuantity,
              subtotal: subtotal,
              totalTax: totalTax,
              grandTotal: grandTotal,
              isLoggedIn: customerAuthSignal.value.value != null,
              walletBalance: _storeWalletBalance,
              useWallet: _useWallet,
              isSubmitting: _isSubmitting,
              onToggleWallet: () => setState(() => _useWallet = !_useWallet),
              onCheckout: _checkoutOrder,
            ),
          ]),
      ],
    );
  }
}
