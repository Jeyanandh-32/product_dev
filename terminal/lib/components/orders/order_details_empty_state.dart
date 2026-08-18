import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Clean placeholder view displayed in the sidebar when no order is selected.
class OrderDetailsEmptyState extends StatelessWidget {
  const OrderDetailsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Box(
          style: BoxStyler()
              .width(64)
              .height(64)
              .borderRadiusAll(const Radius.circular(999))
              .color(const Color(0xFFF3F4F6))
              .alignment(Alignment.center),
          child: const Icon(FLucideIcons.receiptText, size: 28, color: Color(0xFF9CA3AF)),
        ),
        const Gap(14),
        StyledText(
          'No order selected',
          style: TextStyler().fontSize(16).fontWeight(.w800).color(const Color(0xFF000000)),
        ),
        const Gap(8),
        const Text(
          'Select an order from the list to view receipt breakdown',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.5, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
