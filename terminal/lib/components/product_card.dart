import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/providers/cart_provider.dart';

class ProductCard extends SignalWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final cart = cartSignal.value;
    final isExisting =
        cart.items.indexWhere((item) => item.product.id == product.id) >= 0;

    return PressableBox(
      onPress: () => CartController.addItem(product),
      style: BoxStyler()
          .color(isExisting ? theme.colorScheme.accent : Colors.white)
          .paddingAll(12)
          .borderRadiusAll(.circular(16))
          .borderAll(color: theme.colorScheme.border.withValues(alpha: .3))
          .shadowOnly(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 1),
            blurRadius: 3,
          )
          .scale(1.0)
          .onPressed(BoxStyler().scale(0.95))
          .animate(.easeInOut(150.ms)),
      child: ColumnBox(
        style: FlexBoxStyler().mainAxisSize(.min).crossAxisAlignment(.start),
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Box(
                style: BoxStyler().color(const Color(0xFFF1F2F3)),
                child: Image.network(
                  product.imageUrl ?? '',
                  fit: .cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      LucideIcons.image,
                      size: 32,
                      color: Colors.grey.shade400,
                    );
                  },
                ),
              ),
            ),
          ),
          const Gap(12),
          StyledText(
            product.name,
            style: TextStyler()
                .fontSize(14)
                .fontWeight(.w600)
                .color(isExisting ? Colors.white : Colors.grey.shade800)
                .overflow(.ellipsis),
          ),
          const Gap(6),
          StyledText(
            '₹${product.sellingPrice.toStringAsFixed(2)}',
            style: TextStyler()
                .fontSize(14)
                .fontWeight(.bold)
                .color(isExisting ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
