import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Reusable label-value row widget for cart totals and summaries.
class CartSummaryItemRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const CartSummaryItemRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StyledText(
          title,
          style: TextStyler()
              .fontSize(isTotal ? 16 : 13.5)
              .fontWeight(isTotal ? .w800 : .w600)
              .color(
                isTotal
                    ? const Color(0xFF000000)
                    : const Color(0xFF334155),
              ),
        ),
        StyledText(
          value,
          style: TextStyler()
              .fontSize(isTotal ? 18 : 14)
              .fontWeight(isTotal ? .w900 : .w700)
              .color(valueColor ?? const Color(0xFF0F172A)),
        ),
      ],
    );
  }
}
