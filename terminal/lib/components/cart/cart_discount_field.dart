import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// High-contrast readable discount input field for order totals calculation in billing summary.
class CartDiscountField extends StatelessWidget {
  final TextEditingController controller;

  const CartDiscountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 265;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Discount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: TerminalColors.textPrimary,
                  ),
                ),
                if (!isCompact) ...[
                  const Gap(4),
                  const Text(
                    '(optional)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
            Container(
              width: isCompact ? 90 : 105,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8, right: 2),
                    child: Center(
                      widthFactor: 1.0,
                      child: Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: TerminalColors.textPrimary,
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
      },
    );
  }
}
