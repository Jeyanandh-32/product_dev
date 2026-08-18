import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Senior-friendly high-contrast label-value row widget for cart totals and summaries.
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
              .fontSize(isTotal ? 18 : 14.5)
              .fontWeight(isTotal ? .w900 : .w700)
              .color(const Color(0xFF000000)),
        ),
        StyledText(
          value,
          style: TextStyler()
              .fontSize(isTotal ? 22 : 15.5)
              .fontWeight(.w900)
              .color(valueColor ?? const Color(0xFF000000)),
        ),
      ],
    );
  }
}
