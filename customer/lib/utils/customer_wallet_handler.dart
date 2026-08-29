import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/signals/recent_stores_signal.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:customer/utils/phonepe_interop.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Handler for customer wallet and reward balance operations.
class CustomerWalletHandler {
  const CustomerWalletHandler._();

  /// Loads wallet balance and transaction history for the active or recent store.
  static Future<
    ({double balance, List<CustomerWalletTransaction> transactions})
  >
  loadWalletHistory() async {
    final recentStores = recentStoresSignal.value.value ?? const <Store>[];
    final storeId =
        currentCartStoreIdSignal.value ??
        (recentStores.isNotEmpty ? recentStores.first.id : null);
    try {
      final res = await CustomerWalletRepository.getWalletInfo(
        storeId: storeId,
      );
      final currentCustomer = customerAuthSignal.value.value;
      if (currentCustomer != null &&
          currentCustomer.walletBalance != res.balance) {
        customerAuthSignal.value = AsyncData(
          currentCustomer.copyWith(walletBalance: res.balance),
        );
      }
      return (balance: res.balance, transactions: res.transactions);
    } catch (_) {
      return (balance: 0.0, transactions: const <CustomerWalletTransaction>[]);
    }
  }

  /// Initiates top-up transaction via payment gateway or direct credit.
  static Future<void> initiateTopUp({
    required double amount,
    required VoidCallback onModalClose,
    required void Function(bool isLoading) setLoading,
    required Future<void> Function() onCompleted,
  }) async {
    final storeId = currentCartStoreIdSignal.value;
    if (amount <= 0 || storeId == null) return;

    setLoading(true);

    try {
      final res = await CustomerWalletRepository.topUp(
        amount,
        storeId: storeId,
      );

      final tokenUrl = res.tokenUrl;
      final merchantOrderId = res.merchantOrderId;

      if (tokenUrl != null &&
          tokenUrl.isNotEmpty &&
          merchantOrderId != null &&
          merchantOrderId.isNotEmpty) {
        onModalClose();

        openPhonePeCheckoutModal(
          tokenUrl: tokenUrl,
          merchantOrderId: merchantOrderId,
          onComplete: (status) async {
            setLoading(false);
            await onCompleted();

            if (status == 'CONCLUDED') {
              showCustomerToast(
                'Wallet topped up successfully!',
                type: ToastType.success,
              );
            } else {
              showCustomerToast(
                'Top-up payment was cancelled.',
                type: ToastType.warning,
              );
            }
          },
        );
        return;
      }

      setLoading(false);
      onModalClose();
      showCustomerToast(
        'Wallet topped up successfully!',
        type: ToastType.success,
      );
      await onCompleted();
    } catch (e) {
      setLoading(false);
      showCustomerToast(e.toString(), type: ToastType.error);
    }
  }
}
