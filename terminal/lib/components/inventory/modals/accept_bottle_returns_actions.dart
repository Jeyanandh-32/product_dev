import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Bottom action buttons for the manual bottle returns acceptance dialog.
class AcceptBottleReturnsActions extends StatelessWidget {
  const AcceptBottleReturnsActions({
    required this.hasTokens,
    required this.isProcessing,
    required this.totalValue,
    required this.onCancel,
    required this.onComplete,
    super.key,
  });

  final bool hasTokens;
  final bool isProcessing;
  final int totalValue;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final cancelBtnStyle = BoxStyler()
        .height(42)
        .paddingX(18)
        .borderRadiusAll(const Radius.circular(10))
        .color(const Color(0xFFF1F5F9))
        .alignment(Alignment.center)
        .onHovered(BoxStyler().color(const Color(0xFFE2E8F0)));

    final activeCompleteBtnStyle = BoxStyler()
        .height(42)
        .paddingX(20)
        .borderRadiusAll(const Radius.circular(10))
        .color(const Color(0xFF16A34A))
        .alignment(Alignment.center)
        .onHovered(BoxStyler().color(const Color(0xFF15803D)));

    final disabledCompleteBtnStyle = BoxStyler()
        .height(42)
        .paddingX(20)
        .borderRadiusAll(const Radius.circular(10))
        .color(const Color(0xFFCBD5E1))
        .alignment(Alignment.center);

    final completeText = isProcessing
        ? 'Processing...'
        : (hasTokens ? 'Complete Return (₹$totalValue)' : 'Complete Return');

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;

        final cancelBtn = MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: onCancel,
            style: cancelBtnStyle,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
          ),
        );

        final completeBtn = MouseRegion(
          cursor: isProcessing || !hasTokens
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: PressableBox(
            onPress: isProcessing || !hasTokens ? null : onComplete,
            style: hasTokens
                ? activeCompleteBtnStyle
                : disabledCompleteBtnStyle,
            child: Text(
              completeText,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        );

        if (isNarrow) {
          return Row(
            children: [
              Expanded(child: cancelBtn),
              const Gap(10),
              Expanded(flex: 2, child: completeBtn),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [cancelBtn, const Gap(10), completeBtn],
        );
      },
    );
  }
}
