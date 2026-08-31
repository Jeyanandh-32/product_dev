import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:models/models.dart';

/// Action button for renewing, upgrading, or activating a store subscription.
class RenewSubscriptionButton extends StatelessComponent {
  const RenewSubscriptionButton({
    super.key,
    required this.selectedPlanCode,
    required this.subscription,
    required this.isLoading,
    required this.onRenew,
  });

  final SubscriptionPlanCode selectedPlanCode;
  final StoreSubscription? subscription;
  final bool isLoading;
  final VoidCallback onRenew;

  @override
  Component build(BuildContext context) {
    final isYearly = selectedPlanCode == SubscriptionPlanCode.yearly;
    final planTitle = isYearly ? 'Yearly' : 'Monthly';
    final sub = subscription;
    final isBlocked =
        sub?.status == SubscriptionStatus.active &&
        sub?.planCode == selectedPlanCode;

    final txt = isLoading
        ? 'Processing Payment...'
        : isBlocked
        ? 'Current Active Plan'
        : (sub?.status == SubscriptionStatus.gracePeriod ||
              sub?.status == SubscriptionStatus.expired)
        ? 'Renew $planTitle Plan'
        : sub?.planCode == SubscriptionPlanCode.monthly && isYearly
        ? 'Upgrade to Yearly Plan'
        : sub?.planCode == SubscriptionPlanCode.trial || sub == null
        ? 'Pay & Activate $planTitle'
        : 'Switch to $planTitle Plan';

    final cls = isBlocked || isLoading
        ? 'w-full py-3 px-4 rounded-xl font-bold text-sm bg-gray-200 text-gray-400 cursor-not-allowed flex items-center justify-center gap-2'
        : 'w-full py-3 px-4 rounded-xl font-bold text-sm bg-primary text-white hover:bg-primary-hover transition-all flex items-center justify-center gap-2 cursor-pointer shadow-sm';

    return button(
      type: .button,
      onClick: (isBlocked || isLoading) ? null : onRenew,
      classes: cls,
      [
        if (isLoading)
          span(classes: 'loading loading-spinner loading-xs text-white', [])
        else if (isBlocked)
          Check(classes: 'w-4 h-4 text-emerald-600')
        else
          Sparkles(classes: 'w-4 h-4'),
        .text(txt),
      ],
    );
  }
}
