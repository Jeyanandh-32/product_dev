import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';

/// Live summary banner displaying returnable bottle count and estimated deposit value.
class AcceptBottleReturnsSummaryCard extends StatelessWidget {
  const AcceptBottleReturnsSummaryCard({
    required this.bottleCount,
    required this.rewardPerBottle,
    required this.onClearAll,
    super.key,
  });

  final int bottleCount;
  final int rewardPerBottle;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final totalValue = bottleCount * rewardPerBottle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                FLucideIcons.circleCheck,
                size: 16,
                color: Color(0xFF16A34A),
              ),
              const Gap(8),
              Text(
                '$bottleCount bottle${bottleCount == 1 ? '' : 's'} scanned',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15803D),
                ),
              ),
              const Gap(6),
              Text(
                '(@ ₹$rewardPerBottle/ea)',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '₹${totalValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF15803D),
                ),
              ),
              if (bottleCount > 1) ...[
                const Gap(10),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onClearAll,
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
