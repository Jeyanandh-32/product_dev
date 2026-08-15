import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    return ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(CrossAxisAlignment.start)
          .width(double.infinity),
      children: [
        StyledText(
          'Payment Mode',
          style: TextStyler()
              .fontSize(14)
              .fontWeight(.w500)
              .color(Colors.grey.shade700),
        ),
        const Gap(8),
        Align(
          alignment: Alignment.centerLeft,
          child: ShadRadioGroup<PaymentMethod>(
            initialValue: paymentMode,
            onChanged: isCheckingOut ? null : (value) {
              if (value != null) {
                onModeChanged(value);
              }
            },
            axis: Axis.horizontal,
            spacing: 12,
            items: [
              ShadRadio(
                value: PaymentMethod.cash,
                label: StyledText(
                  'Cash',
                  style: TextStyler().fontSize(14),
                ),
              ),
              ShadRadio(
                value: PaymentMethod.upi,
                label: StyledText(
                  'UPI',
                  style: TextStyler().fontSize(14),
                ),
              ),
              ShadRadio(
                value: PaymentMethod.complimentary,
                label: StyledText(
                  'Free/Complimentary',
                  style: TextStyler().fontSize(14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
