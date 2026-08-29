import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List;
import 'package:models/models.dart';

/// Card component representing a selectable subscription plan.
class PlanTierCard extends StatelessComponent {
  const PlanTierCard({
    super.key,
    required this.plan,
    required this.isSelected,
    this.isCurrentPlan = false,
    required this.onSelect,
  });

  final SubscriptionPlan plan;
  final bool isSelected;
  final bool isCurrentPlan;
  final VoidCallback onSelect;

  @override
  Component build(BuildContext context) {
    final isYearly = plan.code == SubscriptionPlanCode.yearly;
    final priceInRupees = (plan.priceInPaise / 100).toStringAsFixed(0);

    return div(
      classes: isSelected
          ? 'p-4 rounded-xl border-2 border-primary bg-primary/5 cursor-pointer relative transition-all'
          : 'p-4 rounded-xl border border-border-medium bg-white hover:border-gray-400 cursor-pointer relative transition-all',
      events: {'click': (_) => onSelect()},
      [
        if (isCurrentPlan)
          span(
            classes:
                'absolute -top-2.5 left-3 bg-emerald-600 text-white text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider',
            [.text('Active Plan')],
          ),
        if (isYearly)
          span(
            classes:
                'absolute -top-2.5 right-3 bg-amber-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider',
            [.text('Save 2 Months')],
          ),
        div(classes: 'flex items-center justify-between', [
          div([
            h4(classes: 'font-bold text-gray-900 text-sm', [.text(plan.name)]),
            p(
              classes: 'text-xs text-gray-500',
              [.text(isYearly ? 'Billed annually' : 'Billed monthly')],
            ),
          ]),
          div(classes: 'text-right', [
            span(
              classes: 'text-base sm:text-lg font-bold text-gray-900',
              [.text('₹$priceInRupees')],
            ),
            span(
              classes: 'text-xs text-gray-500 font-medium',
              [.text(isYearly ? '/yr' : '/mo')],
            ),
          ]),
        ]),
        if (plan.features.isNotEmpty)
          div(classes: 'mt-3 pt-2 border-t border-border-light/80 space-y-1', [
            for (final f in plan.features)
              div(classes: 'flex items-center gap-1.5 text-xs text-gray-600', [
                Check(classes: 'w-3.5 h-3.5 text-primary shrink-0'),
                span([.text(f)]),
              ]),
          ]),
      ],
    );
  }
}
