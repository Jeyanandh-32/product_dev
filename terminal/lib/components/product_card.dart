import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/stepper_circle_button.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Product card styled with the exact customer web store hover effects and animations.
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
    return SignalBuilder(
      builder: (context) {
        final cart = cartSignal.value;
        final cartIndex =
            cart.items.indexWhere((item) => item.product.id == product.id);
        final isExisting = cartIndex >= 0;
        final currentQuantity = isExisting ? cart.items[cartIndex].quantity : 0;

        return MouseRegion(
          cursor: isMobile && isExisting ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: PressableBox(
            onPress: isMobile && isExisting
                ? null
                : () => CartController.addItem(product),
            style: BoxStyler()
                .color(Colors.white)
                .paddingAll(14)
                .borderRadiusAll(Radius.circular(16))
                .borderAll(
                  color: isExisting
                      ? Colors.black
                      : Colors.grey.shade200,
                )
                .shadowOnly(
                  color: Colors.black.withValues(alpha: isExisting ? 0.06 : 0.03),
                  offset: const Offset(0, 2),
                  blurRadius: isExisting ? 6 : 4,
                )
                .scale(1.0)
                .onHovered(
                  BoxStyler()
                      .borderAll(color: Colors.black)
                      .shadowOnly(
                        color: Colors.black.withValues(alpha: 0.08),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                )
                .onPressed(BoxStyler().scale(0.97))
                .animate(AnimationConfig.easeInOut(150.ms)),
          child: ColumnBox(
            style: FlexBoxStyler().mainAxisSize(.min).crossAxisAlignment(.start),
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Box(
                    style: BoxStyler().color(const Color(0xFFF3F4F6)),
                    child: Image.network(
                      product.imageUrl ?? '',
                      fit: BoxFit.cover,
                      cacheWidth: 320,
                      cacheHeight: 220,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            FLucideIcons.image,
                            size: 28,
                            color: Colors.grey.shade400,
                          ),
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
                    .fontWeight(.w800)
                    .color(Colors.black),
              ),
              if (product.description != null && product.description!.trim().isNotEmpty) ...[
                const Gap(4),
                StyledText(
                  product.description!,
                  style: TextStyler()
                      .fontSize(12)
                      .color(Colors.grey.shade500),
                ),
              ],
              const Gap(6),
              StyledText(
                '₹${product.sellingPrice.toStringAsFixed(2)}',
                style: TextStyler()
                    .fontSize(14)
                    .fontWeight(.w900)
                    .color(Colors.black),
              ),
              if (isMobile) ...[
                const Gap(8),
                if (!isExisting)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: PressableBox(
                      onPress: () => CartController.addItem(product),
                      style: BoxStyler()
                          .color(const Color(0xFFF3F4F6))
                          .width(double.infinity)
                          .paddingY(8)
                          .borderRadiusAll(Radius.circular(12))
                          .borderAll(color: Colors.grey.shade200)
                          .onHovered(
                            BoxStyler()
                                .color(Colors.black)
                                .borderAll(color: Colors.black)
                                .textStyle(TextStyler().color(Colors.white)),
                          )
                          .onPressed(BoxStyler().scale(0.98)),
                      child: RowBox(
                        style: FlexBoxStyler()
                            .mainAxisAlignment(MainAxisAlignment.center)
                            .crossAxisAlignment(CrossAxisAlignment.center)
                            .spacing(6),
                        children: [
                          const Icon(FLucideIcons.plus, size: 14, color: Colors.black),
                          StyledText(
                            'Add',
                            style: TextStyler()
                                .fontSize(13)
                                .fontWeight(.w800)
                                .color(Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StepperCircleButton(
                          icon: FLucideIcons.minus,
                          size: 28,
                          iconSize: 13,
                          onTap: () => CartController.updateQuantity(
                            product.id,
                            currentQuantity - 1,
                          ),
                        ),
                        Text(
                          '$currentQuantity',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        StepperCircleButton(
                          icon: FLucideIcons.plus,
                          size: 28,
                          iconSize: 13,
                          onTap: () => CartController.updateQuantity(
                            product.id,
                            currentQuantity + 1,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
        );
      },
    );
  }
}
