import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/bottle_return_signal.dart';

/// Active bottle reward/voucher badge showing the applied discount and remove action.
class CartActiveRewardBadge extends StatelessWidget {
  final num totalDiscount;
  final int appliedCredit;
  final BottlePhysicalCoupon? appliedCoupon;

  const CartActiveRewardBadge({
    super.key,
    required this.totalDiscount,
    required this.appliedCredit,
    required this.appliedCoupon,
  });

  void _handleRemove() {
    if (appliedCredit > 0) {
      BottleReturnActions.removeAvailableCredit();
    }
    if (appliedCoupon != null) {
      BottleReturnActions.removePhysicalCoupon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '-₹${totalDiscount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF15803D),
            ),
          ),
          const Gap(8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _handleRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  FLucideIcons.x,
                  size: 13,
                  color: Color(0xFF15803D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
