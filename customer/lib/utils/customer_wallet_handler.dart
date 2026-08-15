import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:customer/utils/phonepe_interop.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

class CustomerWalletHandler {
  const CustomerWalletHandler._();

  /// Loads wallet balance and transaction history for the active store
  static Future<({double balance, List<CustomerWalletTransaction> transactions})> loadWalletHistory() async {
    final storeId = currentCartStoreIdSignal.value;
    if (storeId == null) {
      return (balance: 0.0, transactions: const <CustomerWalletTransaction>[]);
    }
    try {
      final res = await CustomerWalletRepository.getWalletInfo(storeId: storeId);
      final currentCustomer = customerAuthSignal.value.value;
      if (currentCustomer != null && currentCustomer.walletBalance != res.balance) {
        customerAuthSignal.value = AsyncData(
          currentCustomer.copyWith(walletBalance: res.balance),
        );
      }
      return (balance: res.balance, transactions: res.transactions);
    } catch (_) {
      return (balance: 0.0, transactions: const <CustomerWalletTransaction>[]);
    }
  }

  /// Initiates top-up transaction via payment gateway or direct credit
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

      if (res.tokenUrl != null && res.merchantOrderId != null) {
        onModalClose();

        openPhonePeCheckoutModal(
          tokenUrl: res.tokenUrl!,
          merchantOrderId: res.merchantOrderId!,
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
