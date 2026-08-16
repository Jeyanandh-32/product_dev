import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Floating checkout action bar button styled with customer web monochrome look.
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
            onPress: () => context.push('/cart'),
            style: BoxStyler()
                .color(Colors.black)
                .paddingAll(14)
                .borderRadiusAll(Radius.circular(16))
                .borderAll(color: Colors.grey.shade800)
                .shadowOnly(
                  color: Colors.black.withValues(alpha: 0.25),
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                ),
            child: RowBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(CrossAxisAlignment.center)
                  .mainAxisAlignment(MainAxisAlignment.spaceBetween),
              children: [
                RowBox(
                  style: FlexBoxStyler().spacing(10).crossAxisAlignment(CrossAxisAlignment.center),
                  children: [
                    Box(
                      style: BoxStyler()
                          .color(Colors.white)
                          .paddingX(9)
                          .paddingY(3)
                          .borderRadiusAll(Radius.circular(999)),
                      child: StyledText(
                        '${cart.orderQuantity} ${cart.orderQuantity == 1 ? 'item' : 'items'}',
                        style: TextStyler()
                            .color(Colors.black)
                            .fontSize(12)
                            .fontWeight(.w800),
                      ),
                    ),
                    StyledText(
                      '₹${cart.grandTotal.toStringAsFixed(2)}',
                      style: TextStyler()
                          .color(Colors.white)
                          .fontSize(16)
                          .fontWeight(.w800),
                    ),
                  ],
                ),
                RowBox(
                  style: FlexBoxStyler().spacing(6).crossAxisAlignment(CrossAxisAlignment.center),
                  children: [
                    StyledText(
                      'View Order',
                      style: TextStyler()
                          .color(Colors.white)
                          .fontSize(14)
                          .fontWeight(.w700),
                    ),
                    const Icon(
                      FLucideIcons.arrowRight,
                      color: Colors.white,
                      size: 16,
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
