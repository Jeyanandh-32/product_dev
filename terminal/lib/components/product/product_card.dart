import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/product/product_card_image.dart';
import 'package:terminal/components/product/product_card_stepper.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Product card with upper tap zone to prevent accidental additions during stepper interaction.
class ProductCard extends StatelessWidget {
  final Product product;
  final bool isMobile;

  const ProductCard({super.key, required this.product, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SignalBuilder(
        builder: (context) {
          final isExisting = cartSignal.value.items.any(
            (i) => i.product.id == product.id,
          );

          return Box(
            style: BoxStyler()
                .color(const Color(0xFFFFFFFF))
                .paddingAll(14)
                .borderRadiusAll(const Radius.circular(16))
                .borderAll(
                  color: isExisting
                      ? TerminalColors.primary
                      : const Color(0xFFE5E7EB),
                  width: 1.0,
                )
                .shadowOnly(
                  color: isExisting
                      ? const Color(0x14000000)
                      : const Color(0x08000000),
                  offset: const Offset(0, 2),
                  blurRadius: isExisting ? 6 : 4,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => CartController.addItem(product),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductCardImage(imageUrl: product.imageUrl),
                        const Gap(12),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: TerminalColors.textPrimary,
                          ),
                        ),
                        if (product.description?.trim() case final desc?
                            when desc.isNotEmpty) ...[
                          const Gap(4),
                          Text(
                            desc,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                        const Gap(6),
                        Text(
                          '₹${product.sellingPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: TerminalColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(12),
                ProductCardStepper(product: product),
              ],
            ),
          );
        },
      ),
    );
  }
}
