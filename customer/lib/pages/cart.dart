import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/cart/cart_item_card.dart';
import 'package:customer/components/cart/cart_page_header.dart';
import 'package:customer/components/cart/cart_summary_card.dart';
import 'package:customer/components/cart/empty_cart_state.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/utils/cart_checkout_handler.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
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
      (sum, item) => sum + (item.product.sellingPrice * item.quantity),
    );
    final totalTax = items.fold<double>(
      0.0,
      (sum, item) {
        final taxRate = item.product.taxRate;
        final itemPrice = item.product.sellingPrice * item.quantity;
        return sum + (itemPrice * (taxRate / 100.0));
      },
    );
    final netTotal = subtotal + totalTax;
    final platformFee = netTotal * 0.0199;
    final grandTotal = netTotal + platformFee;
    final totalQuantity = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return div(
      classes: 'max-w-4xl mx-auto w-full flex flex-col gap-8',
      [
        CartPageHeader(
          currentStore: currentStore,
          hasItems: items.isNotEmpty,
        ),

        if (items.isEmpty)
          EmptyCartState(
            currentStore: currentStore,
            onExplore: () {
              if (currentStore?.slug case final slug? when slug.isNotEmpty) {
                Router.of(context).push('/store/$slug');
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
              currentStore: currentStore,
              totalItemCount: items.length,
              totalQuantity: totalQuantity,
              subtotal: subtotal,
              totalTax: totalTax,
              platformFee: platformFee,
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
