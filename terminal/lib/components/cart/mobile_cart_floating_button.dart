import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Floating checkout action bar button styled with Mix [PressableBox].
class MobileCartFloatingButton extends SignalWidget {
  const MobileCartFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = cartSignal.value;
    if (cart.items.isEmpty) return const SizedBox.shrink();

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: SafeArea(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: () => GoRouter.maybeOf(context)?.push('/cart'),
            style: BoxStyler()
                .color(const Color(0xFF000000))
                .paddingAll(14)
                .borderRadiusAll(const Radius.circular(16))
                .borderAll(color: const Color(0xFF1E293B))
                .shadowOnly(
                  color: const Color(0x40000000),
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Box(
                      style: BoxStyler()
                          .color(const Color(0xFFFFFFFF))
                          .paddingX(9)
                          .paddingY(3)
                          .borderRadiusAll(const Radius.circular(999)),
                      child: StyledText(
                        '${cart.orderQuantity} ${cart.orderQuantity == 1 ? 'item' : 'items'}',
                        style: TextStyler()
                            .color(const Color(0xFF000000))
                            .fontSize(12)
                            .fontWeight(.w800),
                      ),
                    ),
                    const Gap(10),
                    StyledText(
                      '₹${cart.grandTotal.toStringAsFixed(2)}',
                      style: TextStyler()
                          .color(const Color(0xFFFFFFFF))
                          .fontSize(15)
                          .fontWeight(.w900),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      'View Order',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Gap(6),
                    Icon(
                      FLucideIcons.arrowRight,
                      size: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
