import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart_checkout_button.dart';
import 'package:terminal/components/cart/cart_totals_breakdown.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Checkout summary card styled identically to customer web app order summary (rounded-3xl / 24px radius).
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

  Future<void> _handleCheckout(String storeId, PaymentMethod paymentMode) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isCheckingOut = true);

    try {
      final order = await CartController.checkout(
        storeId: storeId,
        paymentMethod: paymentMode,
      );

      _discountController.clear();

      if (!mounted) return;
      showFToast(
        context: context,
        alignment: .topCenter,
        duration: const Duration(seconds: 4),
        icon: const Icon(
          FLucideIcons.circleCheck,
          color: Color(0xFF16A34A),
          size: 20,
        ),
        title: const Text(
          'Order Placed Successfully',
          style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold),
        ),
        description: Text('Bill No: #${order.billNo} • Payment: ${paymentMode.name.toUpperCase()}'),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiException
          ? e.message
          : 'Failed to place order. Please try again.';
      showFToast(
        context: context,
        alignment: .topCenter,
        duration: const Duration(seconds: 4),
        icon: const Icon(
          FLucideIcons.circleAlert,
          color: Color(0xFFDC2626),
          size: 20,
        ),
        title: const Text(
          'Order Error',
          style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
        ),
        description: Text(message),
      );
    } finally {
      if (mounted) {
        setState(() => _isCheckingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final cart = cartSignal.value;
        final paymentMode = paymentModeSignal.value;
        final authState = authSignal.value;
        final terminal = authState.value;

        final canCheckout =
            !_isCheckingOut && cart.items.isNotEmpty && terminal != null;

        return Box(
          style: BoxStyler()
              .marginTop(8)
              .paddingAll(20)
              .color(const Color(0xFFFFFFFF))
              .borderRadiusAll(const Radius.circular(24))
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
              const Gap(16),
              CartCheckoutButton(
                canCheckout: canCheckout,
                isCheckingOut: _isCheckingOut,
                paymentMode: paymentMode,
                onCheckout: () {
                  if (terminal != null) {
                    _handleCheckout(terminal.storeId, paymentMode);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
