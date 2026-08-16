import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart_payment_mode_selector.dart';
import 'package:terminal/components/cart_totals_breakdown.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Checkout summary card styled identically to customer web app order summary card.
class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  bool _isCheckingOut = false;
  bool _isButtonHovered = false;
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

        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CartTotalsBreakdown(
                cart: cart,
                paymentMode: paymentMode,
                discountController: _discountController,
              ),
              const Gap(14),
              CartPaymentModeSelector(
                paymentMode: paymentMode,
                isCheckingOut: _isCheckingOut,
                onModeChanged: (value) {
                  if (value != paymentModeSignal.value) {
                    Future.microtask(() {
                      paymentModeSignal.value = value;
                      CartController.setDiscount(discountInputSignal.value);
                    });
                  }
                },
              ),
              const Gap(16),
              MouseRegion(
                cursor: canCheckout ? SystemMouseCursors.click : SystemMouseCursors.basic,
                onEnter: (_) => setState(() => _isButtonHovered = true),
                onExit: (_) => setState(() => _isButtonHovered = false),
                child: GestureDetector(
                  onTap: canCheckout
                      ? () => _handleCheckout(terminal.storeId, paymentMode)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: canCheckout
                          ? (_isButtonHovered ? const Color(0xFF1F2937) : Colors.black)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: canCheckout
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: _isButtonHovered ? 0.25 : 0.15),
                                offset: const Offset(0, 4),
                                blurRadius: _isButtonHovered ? 12 : 8,
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save & Print',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          FLucideIcons.arrowRight,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
