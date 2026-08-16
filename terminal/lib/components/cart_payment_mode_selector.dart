import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';

/// Clean payment method segmented selector matching the customer app UI.
class CartPaymentModeSelector extends StatelessWidget {
  final PaymentMethod paymentMode;
  final bool isCheckingOut;
  final ValueChanged<PaymentMethod> onModeChanged;

  const CartPaymentModeSelector({
    super.key,
    required this.paymentMode,
    required this.isCheckingOut,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final modes = [
      (PaymentMethod.cash, 'Cash', FLucideIcons.banknote),
      (PaymentMethod.upi, 'UPI', FLucideIcons.qrCode),
      (PaymentMethod.complimentary, 'Free', FLucideIcons.gift),
    ];

    return ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(CrossAxisAlignment.start)
          .width(double.infinity),
      children: [
        StyledText(
          'Payment Mode',
          style: TextStyler()
              .fontSize(13)
              .fontWeight(.w700)
              .color(Colors.grey.shade700),
        ),
        const Gap(8),
        RowBox(
          style: FlexBoxStyler()
              .spacing(8)
              .width(double.infinity),
          children: modes.map((mode) {
            final (type, label, icon) = mode;
            final isSelected = paymentMode == type;

            return Expanded(
              child: MouseRegion(
                cursor: isCheckingOut ? SystemMouseCursors.basic : SystemMouseCursors.click,
                child: PressableBox(
                  onPress: isCheckingOut ? null : () => onModeChanged(type),
                  style: BoxStyler()
                      .color(isSelected ? theme.colors.primary : const Color(0xFFF8FAFC))
                      .borderAll(
                        color: isSelected ? theme.colors.primary : theme.colors.border,
                      )
                      .borderRadiusAll(Radius.circular(12))
                      .paddingY(10)
                      .paddingX(8)
                      .shadowOnly(
                        color: Colors.black.withValues(alpha: isSelected ? 0.04 : 0.0),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                  child: RowBox(
                    style: FlexBoxStyler()
                        .mainAxisAlignment(MainAxisAlignment.center)
                        .crossAxisAlignment(CrossAxisAlignment.center)
                        .spacing(6),
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                      StyledText(
                        label,
                        style: TextStyler()
                            .fontSize(13)
                            .fontWeight(isSelected ? .w700 : .w600)
                            .color(isSelected ? Colors.white : Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
