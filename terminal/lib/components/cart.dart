import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:terminal/components/cart_item_row.dart';
import 'package:terminal/components/cart_summary.dart';
import 'package:terminal/providers/cart_provider.dart';

class Cart extends SignalWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cartStyle = FlexBoxStyler()
        .paddingX(16)
        .paddingY(24)
        .color(Colors.white)
        .width(screenWidth * .40)
        .onMobile(.width(.infinity))
        .borderLeft(color: theme.colorScheme.border);
    final cart = cartSignal.value;

    return ColumnBox(
      style: cartStyle,
      children: [
        RowBox(
          style: FlexBoxStyler()
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center),
          children: [
            StyledText(
              'Cart',
              style: TextStyler()
                  .fontSize(22)
                  .fontWeight(.bold)
                  .color(Colors.grey.shade900),
            ),
            PressableBox(
              onPress: () => CartController.clear(),
              style: BoxStyler()
                  .paddingX(12)
                  .paddingY(6)
                  .borderRadiusAll(.circular(8))
                  .onHovered(BoxStyler().color(Colors.red.shade50)),
              child: StyledText(
                'Clear All',
                style: TextStyler()
                    .fontSize(13)
                    .fontWeight(.w600)
                    .color(Colors.red.shade600),
              ),
            ),
          ],
        ),
        const Gap(16),
        Expanded(
          child: cart.items.isEmpty
              ? ColumnBox(
                  style: FlexBoxStyler().mainAxisAlignment(.center),
                  children: [
                    const Icon(LucideIcons.badgeX, size: 24),
                    const Gap(8),
                    StyledText(
                      style: TextStyler().fontSize(16).fontWeight(.w600),
                      'Your current order is empty',
                    ),
                    const Gap(8),
                    StyledText(
                      style: TextStyler().color(Colors.grey.shade600),
                      'Please add some products from the menu',
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
                      return ColumnBox(
                        style: FlexBoxStyler().mainAxisSize(.min),
                        children: [
                          CartItemRow(item: item),
                          const StyledDivider(
                            lineStyle: DividerLineStyle.dashed,
                            thickness: 1.5,
                            indent: 32,
                            endIndent: 32,
                          ),
                        ],
                      );
                    },
                  ),
                ),
        ),
        const CartSummary(),
      ],
    );
  }
}
