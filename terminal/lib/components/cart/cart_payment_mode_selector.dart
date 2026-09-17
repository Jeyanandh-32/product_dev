import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/cart/cart_payment_mode_tab.dart';
import 'package:terminal/theme/terminal_colors.dart';

export 'package:terminal/components/cart/cart_payment_mode_tab.dart';

/// Clean payment method selector tabs positioned side-by-side with large readable tabs.
class CartPaymentModeSelector extends StatelessWidget {
  final PaymentMethod selectedMode;

  const CartPaymentModeSelector({super.key, required this.selectedMode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 310;
        final title = StyledText(
          'Payment Mode',
          style: TextStyler()
              .fontSize(14)
              .fontWeight(.w700)
              .color(TerminalColors.textPrimary),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: _buildTab(
                      PaymentMethod.cash,
                      'Cash',
                      FLucideIcons.banknote,
                    ),
                  ),
                  const Gap(4.5),
                  Expanded(
                    child: _buildTab(
                      PaymentMethod.upi,
                      'UPI',
                      FLucideIcons.qrCode,
                    ),
                  ),
                  const Gap(4.5),
                  Expanded(
                    child: _buildTab(
                      PaymentMethod.complimentary,
                      'Free',
                      FLucideIcons.gift,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: title),
            const Gap(6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTab(PaymentMethod.cash, 'Cash', FLucideIcons.banknote),
                const Gap(4.5),
                _buildTab(PaymentMethod.upi, 'UPI', FLucideIcons.qrCode),
                const Gap(4.5),
                _buildTab(
                  PaymentMethod.complimentary,
                  'Free',
                  FLucideIcons.gift,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTab(PaymentMethod mode, String label, IconData icon) =>
      CartPaymentModeTab(
        mode: mode,
        label: label,
        icon: icon,
        isSelected: selectedMode == mode,
      );
}
