import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Clean Print Bill toggle switch for Order Summary with senior-friendly visibility.
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
              size: 16,
              color: Color(0xFF000000),
            ),
            const Gap(8),
            StyledText(
              'Print Bill',
              style: TextStyler()
                  .fontSize(14.5)
                  .fontWeight(.w700)
                  .color(const Color(0xFF000000)),
            ),
          ],
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: CartController.togglePrintBill,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              width: 42,
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: printBill
                    ? const Color(0xFF000000)
                    : const Color(0xFFCBD5E1),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                alignment: printBill
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 19,
                  height: 19,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 3,
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
