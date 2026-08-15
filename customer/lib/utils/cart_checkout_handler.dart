import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:customer/utils/phonepe_interop.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// Handles customer order checkout, wallet deductions, and PhonePe gateway interactions.
class CartCheckoutHandler {
  const CartCheckoutHandler._();

  /// Initiates order checkout with wallet balance and PhonePe payment SDK.
  static Future<void> initiateCheckout({
    required BuildContext context,
    required bool useWallet,
    required ValueChanged<bool> setSubmitting,
  }) async {
    final customer = customerAuthSignal.value.value;
    if (customer == null) {
      redirectPathSignal.value = '/cart';
      Router.of(context).push('/login');
      return;
    }

    final storeId = currentCartStoreIdSignal.value;
    final items = cartItemsSignal.value.values.toList();
    if (storeId == null || items.isEmpty) return;

    setSubmitting(true);

    try {
      final productsPayload = items
          .map(
            (item) => {
              'productId': item.product.id,
              'quantity': item.quantity,
            },
          )
          .toList();

      final result = await OrderRepository.initiateOnlinePayment(
        storeId: storeId,
        products: productsPayload,
        useWallet: useWallet,
      );

      refreshCustomerAuthSignal();

      if (result.isFullyPaidByWallet || result.tokenUrl == null) {
        clearCart();
        showCustomerToast(
          'Order paid using Customer Wallet!',
          type: ToastType.success,
        );
        Router.of(
          context,
        ).push('/order/status?reference=${result.merchantOrderId}');
        return;
      }

      openPhonePeCheckoutModal(
        tokenUrl: result.tokenUrl!,
        merchantOrderId: result.merchantOrderId,
        onComplete: (status) async {
          if (status == 'CONCLUDED') {
            clearCart();
            Router.of(
              context,
            ).push('/order/status?reference=${result.merchantOrderId}');
          } else {
            setSubmitting(false);
            showCustomerToast(
              'Payment was cancelled.',
              type: ToastType.warning,
            );
            try {
              await OrderRepository.verifyStatus(
                reference: result.merchantOrderId,
              );
            } catch (_) {}
            Router.of(
              context,
            ).push('/order/status?reference=${result.merchantOrderId}');
          }
        },
      );
    } catch (e) {
      setSubmitting(false);
      showCustomerToast(e.toString(), type: ToastType.error);
    }
  }
}
