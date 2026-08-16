import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Clean totals breakdown styled identically to `customer/lib/components/cart/cart_summary_card.dart`.
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
          'Order Summary',
          style: TextStyler()
              .fontSize(16)
              .fontWeight(.w900)
              .color(Colors.black),
        ),
        const Gap(14),
        _summaryRow(
          title: 'Total No of Items',
          value: '${cart.noOfItems}',
        ),
        const Gap(8),
        _summaryRow(
          title: 'Total Order Quantity',
          value: '${cart.orderQuantity}',
        ),
        const Gap(8),
        _summaryRow(
          title: 'Subtotal',
          value: '₹${cart.subtotal.toStringAsFixed(2)}',
        ),
        const Gap(8),
        if (paymentMode != PaymentMethod.complimentary) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Discount (₹)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
              Container(
                width: 90,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: discountController,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 8, right: 2),
                      child: Center(
                        widthFactor: 1.0,
                        child: Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val) ?? 0.0;
                    final maxAllowed = cart.subtotal + cart.taxTotal;
                    if (parsed > maxAllowed && maxAllowed > 0) {
                      discountController.text = maxAllowed.toStringAsFixed(2);
                      discountController.selection = TextSelection.fromPosition(
                        TextPosition(offset: discountController.text.length),
                      );
                      CartController.setDiscount(maxAllowed);
                    } else {
                      CartController.setDiscount(parsed);
                    }
                  },
                ),
              ),
            ],
          ),
          const Gap(8),
        ],
        if (cart.discountTotal > 0) ...[
          _summaryRow(
            title: 'Total Discount',
            value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
            valueColor: const Color(0xFF16A34A),
          ),
          const Gap(8),
        ],
        _summaryRow(
          title: 'Total Tax',
          value: '₹${cart.taxTotal.toStringAsFixed(2)}',
        ),
        const Gap(10),
        Container(
          height: 1,
          color: Colors.grey.shade200,
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            Text(
              '₹${cart.grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
