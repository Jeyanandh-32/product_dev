import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/providers/cart_provider.dart';

class CartItemRow extends ConsumerWidget {
  final CartItem item;

  const CartItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RowBox(
      style: FlexBoxStyler()
          .height(80)
          .spacing(12)
          .paddingAll(8)
          .crossAxisAlignment(CrossAxisAlignment.center),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Box(
              style: BoxStyler().color(const Color(0xFFF9FAFB)),
              child: Image.network(
                item.product.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    LucideIcons.image,
                    size: 24,
                    color: Colors.grey.shade400,
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(CrossAxisAlignment.start)
                .mainAxisAlignment(MainAxisAlignment.center),
            children: [
              StyledText(
                item.product.name,
                style: TextStyler()
                    .fontSize(14)
                    .fontWeight(.w600)
                    .color(Colors.grey.shade900)
                    .overflow(.ellipsis),
              ),
              const Gap(4),
              StyledText(
                '₹${item.product.sellingPrice}.00',
                style: TextStyler()
                    .fontSize(13)
                    .fontWeight(.w500)
                    .color(Colors.grey.shade500),
              ),
            ],
          ),
        ),
        RowBox(
          style: FlexBoxStyler()
              .spacing(8)
              .crossAxisAlignment(CrossAxisAlignment.center),
          children: [
            RowBox(
              style: FlexBoxStyler()
                  .color(const Color(0xFFF3F4F6))
                  .mainAxisSize(.min)
                  .paddingAll(2)
                  .borderRadiusAll(.circular(999))
                  .crossAxisAlignment(CrossAxisAlignment.center),
              children: [
                ShadIconButton(
                  icon: const Icon(LucideIcons.minus),
                  height: 28,
                  width: 28,
                  iconSize: 12,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  decoration: const ShadDecoration(shape: BoxShape.circle),
                  onPressed: () => ref
                      .read(cartProvider.notifier)
                      .updateQuantity(item.product.id, item.quantity - 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StyledText(
                    '${item.quantity}',
                    style: TextStyler().fontSize(13).fontWeight(.w600),
                  ),
                ),
                ShadIconButton(
                  icon: const Icon(LucideIcons.plus),
                  height: 28,
                  width: 28,
                  iconSize: 12,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  decoration: const ShadDecoration(shape: BoxShape.circle),
                  onPressed: () => ref
                      .read(cartProvider.notifier)
                      .updateQuantity(item.product.id, item.quantity + 1),
                ),
              ],
            ),
            ShadIconButton.ghost(
              height: 32,
              width: 32,
              iconSize: 16,
              foregroundColor: Colors.red.shade400,
              hoverBackgroundColor: Colors.red.shade400,
              hoverForegroundColor: Colors.white,
              onPressed: () =>
                  ref.read(cartProvider.notifier).removeItem(item.product.id),
              icon: const Icon(LucideIcons.trash),
            ),
          ],
        ),
      ],
    );
  }
}
