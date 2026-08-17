import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart_clear_all_button.dart';
import 'package:terminal/components/cart/cart_item_row.dart';
import 'package:terminal/components/cart/cart_summary.dart';
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
        .paddingTop(isDrawerMode ? 16 : 20)
        .paddingBottom(isDrawerMode ? 24 : 20)
        .color(
          isDrawerMode
              ? const Color(0xFFF8FAFC)
              : const Color(0xFFFFFFFF),
        )
        .width(cartWidth)
        .borderLeft(
          color: isDrawerMode
              ? const Color(0x00000000)
              : theme.colors.border,
        );
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
                    .color(const Color(0xFF000000)),
              ),
              if (cart.items.isNotEmpty) const CartClearAllButton(),
            ],
          ),
          const Gap(16),
        ],
        Expanded(
          child: cart.items.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Box(
                      style: BoxStyler()
                          .width(64)
                          .height(64)
                          .borderRadiusAll(const Radius.circular(999))
                          .color(const Color(0xFFF3F4F6))
                          .alignment(Alignment.center),
                      child: const Icon(
                        FLucideIcons.shoppingBag,
                        size: 28,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const Gap(12),
                    StyledText(
                      'Your order is empty',
                      style: TextStyler()
                          .fontSize(16)
                          .fontWeight(.w800)
                          .color(const Color(0xFF000000)),
                    ),
                    const Gap(6),
                    const Text(
                      'Tap products from the catalog to build the order ticket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.only(
                    top: isDrawerMode ? 6 : 0,
                    bottom: 12,
                  ),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemRow(item: item);
                  },
                ),
        ),
        const CartSummary(),
      ],
    );
  }
}
