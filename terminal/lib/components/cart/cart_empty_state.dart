import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Clean placeholder view when the POS cart ticket is empty.
class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
