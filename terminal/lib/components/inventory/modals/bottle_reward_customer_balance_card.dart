import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Card showing customer's available reward balance and updated payable total with apply button.
class BottleRewardCustomerBalanceCard extends StatelessWidget {
  final int available;
  final int toApply;
  final bool isApplied;
  final double originalTotal;
  final double updatedTotal;
  final VoidCallback onToggleApply;

  const BottleRewardCustomerBalanceCard({
    super.key,
    required this.available,
    required this.toApply,
    required this.isApplied,
    required this.originalTotal,
    required this.updatedTotal,
    required this.onToggleApply,
  });

  @override
  Widget build(BuildContext context) {
    final btnStyle = BoxStyler()
        .height(32)
        .paddingX(12)
        .borderRadiusAll(const Radius.circular(8))
        .color(isApplied ? const Color(0xFF16A34A) : const Color(0xFFFFFFFF))
        .borderAll(color: const Color(0xFF16A34A), width: 1.2)
        .alignment(Alignment.center)
        .onHovered(
          BoxStyler().color(
            isApplied ? const Color(0xFF15803D) : const Color(0xFFF0FDF4),
          ),
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(FLucideIcons.wallet, size: 18, color: Color(0xFF16A34A)),
                  const Gap(8),
                  Text(
                    'Available: ₹$available',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: onToggleApply,
                  style: btnStyle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isApplied ? FLucideIcons.check : FLucideIcons.plus,
                        size: 13,
                        color: isApplied ? const Color(0xFFFFFFFF) : const Color(0xFF16A34A),
                      ),
                      const Gap(4),
                      Text(
                        isApplied ? 'Applied (-₹$toApply)' : 'Apply -₹$toApply',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isApplied ? const Color(0xFFFFFFFF) : const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isApplied) ...[
            const Gap(8),
            Container(height: 1, color: const Color(0xFFDCFCE7)),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Updated Payable Total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '₹${originalTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      '₹${updatedTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
