import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:terminal/components/cart_payment_mode_selector.dart';
import 'package:terminal/components/cart_totals_breakdown.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

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
    setState(() => _isCheckingOut = true);

    try {
      final order = await CartController.checkout(
        storeId: storeId,
        paymentMethod: paymentMode,
      );

      _discountController.clear();

      if (!mounted) return;
      ShadToaster.of(context).show(
        ShadToast(
          description: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.check, size: 20),
              const Gap(8),
              StyledText('Order no:${order.billNo} placed successfully!'),
            ],
          ),
          alignment: Alignment.topCenter,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiException
          ? e.message
          : 'Failed to place order. Please try again.';
      ShadToaster.of(context).show(
        ShadToast.destructive(
          description: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.x, color: Colors.white, size: 20),
              const Gap(8),
              Text(message),
            ],
          ),
          alignment: Alignment.topCenter,
          duration: const Duration(seconds: 4),
        ),
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

        return ColumnBox(
          style: FlexBoxStyler()
              .paddingTop(16)
              .crossAxisAlignment(CrossAxisAlignment.start),
          children: [
            CartTotalsBreakdown(
              cart: cart,
              paymentMode: paymentMode,
              discountController: _discountController,
            ),
            const Gap(4),
            const StyledDivider(lineStyle: DividerLineStyle.dashed),
            const Gap(16),
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
            const Gap(24),
            ShadButton(
              width: double.infinity,
              height: 44,
              enabled:
                  !_isCheckingOut && cart.items.isNotEmpty && terminal != null,
              onPressed: () {
                if (terminal != null) {
                  _handleCheckout(terminal.storeId, paymentMode);
                }
              },
              child: _isCheckingOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : StyledText(
                      'Save & Print',
                      style: TextStyler().fontSize(16),
                    ),
            ),
          ],
        );
      },
    );
  }
}
