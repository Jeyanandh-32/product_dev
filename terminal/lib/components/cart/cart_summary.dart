import 'package:client_repositories/client_repositories.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart_checkout_button.dart';
import 'package:terminal/components/cart/cart_totals_breakdown.dart';
import 'package:terminal/components/inventory/modals/bottle_reward_mode_dialog.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Checkout summary card with total breakdown and bottle reward mode handling.
class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  bool _isCheckingOut = false;
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckout(
    Terminal terminal,
    PaymentMethod paymentMode,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isBottleReturnStore =
        bottleReturnConfigSignal.value?.isEnabled ?? false;
    BottleRewardMode rewardMode = BottleRewardMode.digital;
    String? customerPhone;

    if (isBottleReturnStore) {
      final defaultPhone = activeCustomerPhoneSignal.value;
      final rewardSelection = await BottleRewardModeDialog.show(
        context,
        initialPhone: defaultPhone,
      );
      if (rewardSelection == null) return;
      rewardMode = rewardSelection.mode;
      customerPhone = rewardSelection.phone;
    }

    setState(() => _isCheckingOut = true);
    try {
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

      _discountController.clear();
      if (!mounted) return;
      TerminalToast.showSuccess(
        context: context,
        title: 'Order Placed Successfully',
        description:
            'Bill No: #${order.billNo} • Payment: ${paymentMode.name.toUpperCase()}',
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiException
          ? e.message
          : 'Failed to place order. Please try again.';
      TerminalToast.showError(
        context: context,
        title: 'Order Error',
        description: message,
      );
    } finally {
      if (mounted) setState(() => _isCheckingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final cart = cartSignal.value;
        final paymentMode = paymentModeSignal.value;
        final terminal = authSignal.value.value;
        final canCheckout =
            !_isCheckingOut && cart.items.isNotEmpty && terminal != null;

        return Box(
          style: BoxStyler()
              .marginTop(8)
              .paddingAll(14)
              .color(const Color(0xFFFFFFFF))
              .borderRadiusAll(const Radius.circular(20))
              .borderAll(color: const Color(0xFFE5E7EB))
              .shadowOnly(
                color: const Color(0x08000000),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CartTotalsBreakdown(
                cart: cart,
                paymentMode: paymentMode,
                discountController: _discountController,
              ),
              const Gap(12),
              CartCheckoutButton(
                canCheckout: canCheckout,
                isCheckingOut: _isCheckingOut,
                paymentMode: paymentMode,
                onCheckout: () {
                  if (terminal != null) _handleCheckout(terminal, paymentMode);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
