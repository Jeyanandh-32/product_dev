import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Active bottle return configuration for the current terminal's store.
final bottleReturnConfigSignal = signal<BottleReturnConfig?>(null);

/// Currently active customer phone number entered for rewards.
final activeCustomerPhoneSignal = signal<String?>(null);

/// Available digital reward credit balance for current customer phone.
final customerPhoneBottleBalanceSignal = signal<int>(0);

/// Bottle reward credit amount applied to the current cart.
final appliedBottleCreditSignal = signal<int>(0);

/// Physical coupon voucher applied to the current cart.
final appliedPhysicalCouponSignal = signal<BottlePhysicalCoupon?>(null);

/// Loading state while checking customer phone credit balance.
final isCheckingBottleCreditSignal = signal<bool>(false);

/// Helper actions for bottle return credit and coupon management in Terminal POS.
class BottleReturnActions {
  const BottleReturnActions._();

  /// Loads store configuration to check if bottle return feature is active.
  static Future<void> loadConfig() async {
    final storeId = authSignal.value.value?.storeId;
    if (storeId == null) {
      bottleReturnConfigSignal.value = null;
      return;
    }
    final cfg = await BottleReturnClientRepository.getConfig(storeId);
    bottleReturnConfigSignal.value = cfg;
  }

  /// Checks available phone balance for a customer and remembers active phone.
  static Future<void> checkCustomerBalance(String phone) async {
    final merchantId = authSignal.value.value?.merchantId;
    final cleanPhone = phone.trim();
    if (merchantId == null || cleanPhone.isEmpty || cleanPhone.length < 10) {
      customerPhoneBottleBalanceSignal.value = 0;
      appliedBottleCreditSignal.value = 0;
      activeCustomerPhoneSignal.value = null;
      CartController.recalculateTotals();
      return;
    }
    activeCustomerPhoneSignal.value = cleanPhone;
    isCheckingBottleCreditSignal.value = true;
    try {
      final bal = await BottleReturnClientRepository.getPhoneCreditBalance(
        phone: cleanPhone,
        merchantId: merchantId,
      );
      customerPhoneBottleBalanceSignal.value = bal;
    } finally {
      isCheckingBottleCreditSignal.value = false;
    }
  }

  /// Toggles or applies available digital credit up to cart subtotal.
  static void applyAvailableCredit() {
    final available = customerPhoneBottleBalanceSignal.value;
    final currentApplied = appliedBottleCreditSignal.value;
    if (currentApplied > 0) {
      appliedBottleCreditSignal.value = 0;
      CartController.recalculateTotals();
      return;
    }
    final cartTotal = cartSignal.value.subtotal.toInt();
    final toApply = available > cartTotal ? cartTotal : available;
    appliedBottleCreditSignal.value = toApply;
    CartController.recalculateTotals();
  }

  /// Removes any applied digital credit.
  static void removeAvailableCredit() {
    appliedBottleCreditSignal.value = 0;
    CartController.recalculateTotals();
  }

  /// Validates and applies a physical paper coupon voucher.
  static Future<bool> applyPhysicalCoupon(String code) async {
    final merchantId = authSignal.value.value?.merchantId;
    final storeId = authSignal.value.value?.storeId;
    if (merchantId == null || storeId == null || code.trim().isEmpty) {
      return false;
    }

    final coupon = await BottleReturnClientRepository.validatePhysicalCoupon(
      merchantId: merchantId,
      code: code.trim(),
      storeId: storeId,
    );
    if (coupon != null) {
      appliedPhysicalCouponSignal.value = coupon;
      CartController.recalculateTotals();
      return true;
    }
    return false;
  }

  /// Clears any applied physical coupon.
  static void removePhysicalCoupon() {
    appliedPhysicalCouponSignal.value = null;
    CartController.recalculateTotals();
  }

  /// Resets all cart-level bottle reward state.
  static void resetCartRewardState() {
    customerPhoneBottleBalanceSignal.value = 0;
    appliedBottleCreditSignal.value = 0;
    appliedPhysicalCouponSignal.value = null;
    activeCustomerPhoneSignal.value = null;
    CartController.recalculateTotals();
  }
}
