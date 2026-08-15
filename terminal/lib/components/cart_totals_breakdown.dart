import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:terminal/signals/cart_signal.dart';

class CartTotalsBreakdown extends StatelessWidget {
  final CartState cart;
  final PaymentMethod paymentMode;
  final TextEditingController discountController;

  const CartTotalsBreakdown({
    super.key,
    required this.cart,
    required this.paymentMode,
    required this.discountController,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(CrossAxisAlignment.start),
      children: [
        StyledText(
          'Summary',
          style: TextStyler().fontSize(16).fontWeight(.w600),
        ),
        const Gap(16),
        _summaryTile(
          title: 'Total No of Items',
          value: '${cart.noOfItems}',
        ),
        const Gap(4),
        _summaryTile(
          title: 'Total Order Quantity',
          value: '${cart.orderQuantity}',
        ),
        const Gap(4),
        _summaryTile(
          title: 'Order Summary',
          value: '₹${cart.subtotal.toStringAsFixed(2)}',
        ),
        const Gap(4),
        if (paymentMode != PaymentMethod.complimentary) ...[
          RowBox(
            style: FlexBoxStyler()
                .mainAxisAlignment(MainAxisAlignment.spaceBetween)
                .crossAxisAlignment(CrossAxisAlignment.center),
            children: [
              StyledText(
                'Discount (₹)',
                style: TextStyler().color(Colors.grey.shade600),
              ),
              SizedBox(
                width: 100,
                height: 32,
                child: ShadInput(
                  controller: discountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  placeholder: const Text('0.00'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val) ?? 0.0;
                    CartController.setDiscount(parsed);
                  },
                ),
              ),
            ],
          ),
          const Gap(4),
        ],
        if (cart.discountTotal > 0) ...[
          _summaryTile(
            title: 'Total Discount',
            value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
          ),
          const Gap(4),
        ],
        _summaryTile(
          title: 'Total Tax',
          value: '₹${cart.taxTotal.toStringAsFixed(2)}',
        ),
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
              '₹${cart.grandTotal.toStringAsFixed(2)}',
              style: TextStyler().fontSize(16).fontWeight(.bold),
            ),
          ],
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
