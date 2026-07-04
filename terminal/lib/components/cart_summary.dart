import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:terminal/providers/cart_provider.dart';
import 'package:terminal/providers/ui_providers.dart';

class CartSummary extends ConsumerWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return ColumnBox(
      style: FlexBoxStyler().paddingTop(16),
      children: [
        StyledText(
          'Summary',
          style: TextStyler().fontSize(16).fontWeight(.w600),
        ),
        const Gap(16),
        _summaryTile(title: 'Total No of Items', value: '${cart.noOfItems}'),
        const Gap(4),
        _summaryTile(
          title: 'Total Order Quantity',
          value: '${cart.orderQuantity}',
        ),
        const Gap(4),
        _summaryTile(title: 'Order Summary', value: '₹${cart.subtotal}0'),
        const Gap(4),
        _summaryTile(title: 'Total Tax', value: '₹${cart.taxTotal}0'),
        const Gap(4),
        const StyledDivider(lineStyle: DividerLineStyle.dashed),
        const Gap(4),
        RowBox(
          style: FlexBoxStyler().mainAxisAlignment(.spaceBetween),
          children: [
            StyledText(
              'Total Amount',
              style: TextStyler().fontSize(16).fontWeight(.bold),
            ),
            StyledText(
              '₹${cart.grandTotal}0',
              style: TextStyler().fontSize(16).fontWeight(.bold),
            ),
          ],
        ),
        const Gap(4),
        const StyledDivider(lineStyle: DividerLineStyle.dashed),
        const Gap(16),
        RowBox(
          style: FlexBoxStyler()
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center),
          children: [
            StyledText(
              'Payment Mode',
              style: TextStyler()
                  .fontSize(14)
                  .fontWeight(.w500)
                  .color(Colors.grey.shade700),
            ),
            ShadRadioGroup<String>(
              initialValue: ref.watch(paymentModeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(paymentModeProvider.notifier).setPaymentMode(value);
                }
              },
              axis: Axis.horizontal,
              spacing: 16,
              items: [
                ShadRadio(
                  value: 'cash',
                  label: StyledText('Cash', style: TextStyler().fontSize(14)),
                ),
                ShadRadio(
                  value: 'upi',
                  label: StyledText('UPI', style: TextStyler().fontSize(14)),
                ),
              ],
            ),
          ],
        ),
        const Gap(24),
        ShadButton(
          width: double.infinity,
          height: 44,
          child: StyledText('Save & Print', style: TextStyler().fontSize(16)),
        ),
      ],
    );
  }

  RowBox _summaryTile({required String title, required String value}) {
    return RowBox(
      style: FlexBoxStyler().mainAxisAlignment(.spaceBetween),
      children: [
        StyledText(title, style: TextStyler().color(Colors.grey.shade600)),
        StyledText(value, style: TextStyler().fontWeight(.bold)),
      ],
    );
  }
}
