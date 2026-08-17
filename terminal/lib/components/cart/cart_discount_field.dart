import 'package:flutter/material.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Ultra-compact discount input field for order totals calculation.
class CartDiscountField extends StatelessWidget {
  final TextEditingController controller;

  const CartDiscountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Discount (₹)',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        Container(
          width: 84,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 6, right: 2),
                child: Center(
                  widthFactor: 1.0,
                  child: Text(
                    '₹',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: '0.00',
              hintStyle: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 6),
              border: InputBorder.none,
              isCollapsed: true,
            ),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000),
            ),
            onChanged: (val) {
              final cart = cartSignal.value;
              final parsed = double.tryParse(val) ?? 0.0;
              final maxAllowed = cart.subtotal + cart.taxTotal;
              if (parsed > maxAllowed && maxAllowed > 0) {
                controller.text = maxAllowed.toStringAsFixed(2);
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
                CartController.setDiscount(maxAllowed);
              } else {
                CartController.setDiscount(parsed);
              }
            },
          ),
        ),
      ],
    );
  }
}
