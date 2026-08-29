import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Service for orchestrating terminal checkout operations and bottle return rewards.
class TerminalCheckoutHandler {
  const TerminalCheckoutHandler._();

  /// Executes checkout order and generates bottle return tokens if enabled.
  static Future<Order> processCheckout({
    required Terminal terminal,
    required PaymentMethod paymentMode,
    required bool isBottleReturnStore,
    required BottleRewardMode rewardMode,
    String? customerPhone,
  }) async {
    final cartItems = List<CartItem>.from(cartSignal.value.items);
    final appliedCredit = appliedBottleCreditSignal.value;
    final appliedCoupon = appliedPhysicalCouponSignal.value;

    final order = await CartController.checkout(
      storeId: terminal.storeId,
      paymentMethod: paymentMode,
    );

    if (isBottleReturnStore) {
      await BottleReturnClientRepository.generateTokens(
        merchantId: terminal.merchantId,
        storeId: terminal.storeId,
        orderId: order.id,
        items: cartItems
            .map(
              (CartItem i) => {
                'productId': i.product.id,
                'quantity': i.quantity,
                'isReturnableBottle': true,
              },
            )
            .toList(),
        rewardMode: rewardMode,
        customerPhone: customerPhone,
      );

      if (appliedCredit > 0 && customerPhone != null) {
        await BottleReturnClientRepository.applyCreditDeduction(
          merchantId: terminal.merchantId,
          customerPhone: customerPhone,
          amount: appliedCredit,
          storeId: terminal.storeId,
          orderId: order.id,
        );
      }
      if (appliedCoupon != null) {
        await BottleReturnClientRepository.redeemPhysicalCoupon(
          merchantId: terminal.merchantId,
          code: appliedCoupon.code,
          storeId: terminal.storeId,
          orderId: order.id,
        );
      }
      BottleReturnActions.resetCartRewardState();
    }

    return order;
  }
}

