import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Ultra-compact Print Bill toggle switch for Order Summary.
class CartPrintBillToggle extends SignalWidget {
  const CartPrintBillToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final printBill = printBillSignal.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FLucideIcons.printer,
              size: 13,
              color: Color(0xFF6B7280),
            ),
            const Gap(6),
            StyledText(
              'Print Bill',
              style: TextStyler()
                  .fontSize(13.5)
                  .fontWeight(.w600)
                  .color(const Color(0xFF334155)),
            ),
          ],
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => CartController.togglePrintBill(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              width: 36,
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: printBill
                    ? const Color(0xFF000000)
                    : const Color(0xFFE2E8F0),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                alignment: printBill
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
