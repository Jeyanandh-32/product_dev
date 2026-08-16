import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart_item_row.dart';
import 'package:terminal/components/cart_summary.dart';
import 'package:terminal/signals/cart_signal.dart';

/// POS cart sidebar / drawer component using customer web app layouts and cards.
class Cart extends SignalWidget {
  final bool isDrawerMode;

  const Cart({super.key, this.isDrawerMode = false});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cartWidth = isDrawerMode
        ? double.infinity
        : screenWidth < 1200
            ? 370.0
            : screenWidth * .38;

    final cartStyle = FlexBoxStyler()
        .paddingX(isDrawerMode ? 16 : 20)
        .paddingY(20)
        .color(isDrawerMode ? const Color(0xFFF8FAFC) : Colors.white)
        .width(cartWidth)
        .borderLeft(color: isDrawerMode ? Colors.transparent : theme.colors.border);
    final cart = cartSignal.value;

    return ColumnBox(
      style: cartStyle,
      children: [
        if (!isDrawerMode) ...[
          RowBox(
            style: FlexBoxStyler()
                .mainAxisAlignment(MainAxisAlignment.spaceBetween)
                .crossAxisAlignment(CrossAxisAlignment.center),
            children: [
              StyledText(
                'Current Order',
                style: TextStyler()
                    .fontSize(20)
                    .fontWeight(.w900)
                    .color(Colors.black),
              ),
              if (cart.items.isNotEmpty)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: () => CartController.clear(),
                    style: BoxStyler()
                        .paddingX(14)
                        .paddingY(6)
                        .borderRadiusAll(Radius.circular(999))
                        .color(const Color(0xFFFEF2F2))
                        .borderAll(color: const Color(0xFFFECACA))
                        .textStyle(
                          TextStyler()
                              .fontSize(12)
                              .fontWeight(.w800)
                              .color(const Color(0xFFDC2626)),
                        )
                        .onHovered(
                          BoxStyler()
                              .color(const Color(0xFFDC2626))
                              .borderAll(color: const Color(0xFFDC2626))
                              .textStyle(TextStyler().color(Colors.white)),
                        )
                        .onPressed(BoxStyler().scale(0.96)),
                    child: const StyledText('Clear All'),
                  ),
                ),
            ],
          ),
          const Gap(16),
        ],
        Expanded(
          child: cart.items.isEmpty
              ? ColumnBox(
                  style: FlexBoxStyler().mainAxisAlignment(.center),
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        FLucideIcons.shoppingBag,
                        size: 28,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const Gap(12),
                    StyledText(
                      'Your order is empty',
                      style: TextStyler()
                          .fontSize(16)
                          .fontWeight(.w800)
                          .color(Colors.black),
                    ),
                    const Gap(6),
                    StyledText(
                      'Tap products from the catalog to build the order ticket',
                      style: TextStyler()
                          .fontSize(13)
                          .color(Colors.grey.shade500)
                          .textAlign(.center),
                    ),
                  ],
                )
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartItemRow(item: item);
                    },
                  ),
                ),
        ),
        const CartSummary(),
      ],
    );
  }
}
