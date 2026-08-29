import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Banner alerting cashiers when store subscription is in grace period or expired.
class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key, required this.subscription});

  final StoreSubscription subscription;

  @override
  Widget build(BuildContext context) {
    if (subscription.status == SubscriptionStatus.active ||
        subscription.status == SubscriptionStatus.trial) {
      return const SizedBox.shrink();
    }

    final isExpired = subscription.status == SubscriptionStatus.expired ||
        subscription.status == SubscriptionStatus.canceled;

    final bgColor =
        isExpired ? TerminalColors.inactiveBadgeBg : TerminalColors.lowStockBadgeBg;
    final borderColor =
        isExpired ? TerminalColors.inactiveBadgeBorder : TerminalColors.lowStockBadgeBorder;
    final textColor =
        isExpired ? TerminalColors.inactiveBadgeText : TerminalColors.lowStockBadgeText;

    final title = isExpired
        ? 'Store Subscription Expired — Billing Locked'
        : 'Subscription Grace Period (3 Days Remaining)';
    final message = isExpired
        ? 'New order checkout is disabled until renewed in the Merchant Portal.'
        : 'Store subscription is due for renewal. Please renew soon to avoid billing interruption.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Icon(
            isExpired ? FLucideIcons.circleAlert : FLucideIcons.triangleAlert,
            size: 18,
            color: textColor,
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textColor.withAlpha(220),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
