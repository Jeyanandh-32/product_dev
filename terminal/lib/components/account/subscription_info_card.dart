import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/account/account_card_header.dart';
import 'package:terminal/components/account/account_info_row.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Card displaying store subscription and POS license status.
class SubscriptionInfoCard extends StatelessWidget {
  final Store? store;
  final StoreSubscription? subscription;

  const SubscriptionInfoCard({
    super.key,
    required this.store,
    this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final sub = subscription;
    final isSubActive = sub != null
        ? sub.status.isOperational
        : (store?.isActive ?? false);
    final statusText = sub != null
        ? switch (sub.status) {
            SubscriptionStatus.trial => '14-Day Free Trial',
            SubscriptionStatus.active => 'Active & Operational',
            SubscriptionStatus.gracePeriod => 'Grace Period (Renewal Due)',
            SubscriptionStatus.expired => 'Expired',
            SubscriptionStatus.canceled => 'Canceled',
          }
        : (isSubActive ? 'Active & Operational' : 'Inactive');

    final planTierText = sub != null
        ? switch (sub.planCode) {
            SubscriptionPlanCode.trial => '14-Day Free Trial',
            SubscriptionPlanCode.monthly => 'Pro Monthly (₹299/mo)',
            SubscriptionPlanCode.yearly => 'Pro Yearly (₹2,999/yr)',
          }
        : 'Sparrow POS License';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TerminalColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.isMobile ? 14 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountCardHeader(
            icon: FLucideIcons.creditCard,
            title: 'Store Subscription',
            subtitle: 'Software license & plan status',
          ),
          const Gap(18),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const Gap(16),
          AccountInfoRow(label: 'Plan Tier', value: planTierText),
          const Gap(14),
          AccountInfoRow(
            label: 'License Status',
            value: statusText,
            isSuccess: isSubActive,
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Bound Store',
            value: store?.name ?? 'Unassigned',
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Auto Renew',
            value: sub?.autoRenew ?? true ? 'Enabled' : 'Disabled',
          ),
        ],
      ),
    );
  }
}
