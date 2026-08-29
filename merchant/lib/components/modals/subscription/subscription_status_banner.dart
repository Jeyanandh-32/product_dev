import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:models/models.dart';

/// Banner displaying current store subscription status and validity expiration.
class SubscriptionStatusBanner extends StatelessComponent {
  const SubscriptionStatusBanner({
    super.key,
    this.subscription,
    this.plan,
  });

  final StoreSubscription? subscription;
  final SubscriptionPlan? plan;

  @override
  Component build(BuildContext context) {
    final sub = subscription;
    final statusText = sub != null ? sub.status.name.toUpperCase() : 'NO PLAN';
    final isOperational = sub?.status.isOperational ?? false;
    final planName = plan?.name ??
        (sub != null
            ? switch (sub.planCode) {
                SubscriptionPlanCode.yearly => 'Pro Yearly (₹2,999/yr)',
                SubscriptionPlanCode.monthly => 'Pro Monthly (₹299/mo)',
                SubscriptionPlanCode.trial => '14-Day Free Trial',
              }
            : 'No Active Plan');

    return div(
      classes:
          'p-3.5 rounded-xl border border-border-medium bg-neutral/30 flex items-center justify-between',
      [
        div(classes: 'flex items-center gap-2.5', [
          CreditCard(classes: 'w-4 h-4 text-primary'),
          div([
            div(classes: 'flex items-center gap-2', [
              span(
                classes: 'text-xs font-bold text-gray-900',
                [.text(planName)],
              ),
              span(
                classes:
                    'text-[10px] font-bold px-1.5 py-0.5 rounded uppercase tracking-wider ${isOperational ? 'bg-emerald-50 text-emerald-700 border border-emerald-200' : 'bg-red-50 text-red-600 border border-red-200'}',
                [.text(statusText)],
              ),
            ]),
            if (sub != null)
              p(classes: 'text-[11px] text-gray-500', [
                .text(
                  'Valid until: ${sub.endsAt.year}-${sub.endsAt.month.toString().padLeft(2, '0')}-${sub.endsAt.day.toString().padLeft(2, '0')}',
                ),
              ]),
          ]),
        ]),
      ],
    );
  }
}
