import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/product/product_card_image.dart';
import 'package:terminal/components/product/product_card_stepper.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Product card with high-contrast active border indicator for selected products in cart.
class ProductCard extends StatelessWidget {
  final Product product;
  final bool isMobile;

  const ProductCard({
    super.key,
    required this.product,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SignalBuilder(
        builder: (context) {
          final isExisting = cartSignal.value.items.any((i) => i.product.id == product.id);

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: PressableBox(
              onPress: () => CartController.addItem(product),
              style: BoxStyler()
                  .color(const Color(0xFFFFFFFF))
                  .paddingAll(14)
                  .borderRadiusAll(const Radius.circular(16))
                  .borderAll(
                    color: isExisting ? const Color(0xFF000000) : const Color(0xFFE5E7EB),
                    width: isExisting ? 2.0 : 1.5,
                  )
                  .shadowOnly(
                    color: isExisting ? const Color(0x14000000) : const Color(0x08000000),
                    offset: const Offset(0, 2),
                    blurRadius: isExisting ? 6 : 4,
                  )
                  .onHovered(
                    BoxStyler()
                        .borderAll(color: const Color(0xFF000000), width: 1.5)
                        .shadowOnly(
                          color: const Color(0x14000000),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      color: Color(0xFF000000),
                    ),
                  ),
                  if (product.description != null && product.description!.trim().isNotEmpty) ...[
                    const Gap(4),
                    Text(
                      product.description!,
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
                      color: Color(0xFF000000),
                    ),
                  ),
                  const Gap(12),
                  ProductCardStepper(product: product),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
