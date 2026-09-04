import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Label-value row widget for cart totals, summaries, and popovers with customizable typography weights.
class CartSummaryItemRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool isTotal;
  final FontWeight? titleFontWeight;
  final FontWeight? valueFontWeight;
  final Color? titleColor;
  final double? titleFontSize;
  final double? valueFontSize;

  const CartSummaryItemRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.isTotal = false,
    this.titleFontWeight,
    this.valueFontWeight,
    this.titleColor,
    this.titleFontSize,
    this.valueFontSize,
  });

  /// High-readability medium weight row tailored for mobile popover dialogs and detail cards.
  const CartSummaryItemRow.popover({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
  }) : isTotal = false,
       titleFontWeight = FontWeight.w500,
       valueFontWeight = FontWeight.w600,
       titleColor = const Color(0xFF475569),
       titleFontSize = 13.5,
       valueFontSize = 13.5;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: StyledText(
            title,
            style: TextStyler()
                .fontSize(titleFontSize ?? (isTotal ? 18 : 14))
                .fontWeight(titleFontWeight ?? (isTotal ? .w900 : .w700))
                .color(titleColor ?? const Color(0xFF000000)),
          ),
        ),
        const Gap(8),
        StyledText(
          value,
          style: TextStyler()
              .fontSize(valueFontSize ?? (isTotal ? 22 : 15))
              .fontWeight(valueFontWeight ?? .w900)
              .color(valueColor ?? const Color(0xFF0F172A)),
        ),
      ],
    );
  }
}
