import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Checkout button with animated hover and loading state using Mix [PressableBox].
class CartCheckoutButton extends StatelessWidget {
  final bool canCheckout;
  final bool isCheckingOut;
  final PaymentMethod paymentMode;
  final VoidCallback onCheckout;

  const CartCheckoutButton({
    super.key,
    required this.canCheckout,
    required this.isCheckingOut,
    required this.paymentMode,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final modeLabel = switch (paymentMode) {
      PaymentMethod.cash => 'CASH',
      PaymentMethod.upi => 'UPI',
      PaymentMethod.complimentary => 'FREE',
    };

    return SizedBox(
      width: double.infinity,
      child: PressableBox(
        onPress: (canCheckout && !isCheckingOut) ? onCheckout : null,
        style: BoxStyler()
            .alignment(Alignment.center)
            .height(48)
            .borderRadiusAll(const Radius.circular(16))
            .color(
              canCheckout ? TerminalColors.primary : const Color(0xFFE2E8F0),
            )
            .onHovered(
              canCheckout
                  ? BoxStyler()
                        .color(TerminalColors.primaryHover)
                        .shadowOnly(
                          color: const Color(0x380B132B),
                          offset: const Offset(0, 4),
                          blurRadius: 14,
                        )
                  : BoxStyler(),
            ),
        child: Center(
          child: isCheckingOut
              ? FCircularProgress(
                  style: FCircularProgressStyle(
                    iconStyle: const IconThemeData(
                      size: 20,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FLucideIcons.shoppingBag,
                      size: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                    const Gap(8),
                    StyledText(
                      'Place Order ($modeLabel)',
                      style: TextStyler()
                          .fontSize(14)
                          .fontWeight(.w800)
                          .color(
                            canCheckout
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF94A3B8),
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
