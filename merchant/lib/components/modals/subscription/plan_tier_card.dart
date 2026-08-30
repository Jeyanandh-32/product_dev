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
          ? 'p-5 rounded-2xl border-2 border-primary bg-primary/5 cursor-pointer relative transition-all shadow-xs'
          : 'p-5 rounded-2xl border border-border-medium bg-white hover:border-gray-400 cursor-pointer relative transition-all shadow-2xs',
      events: {'click': (_) => onSelect()},
      [
        if (isCurrentPlan)
          span(
            classes: 'absolute -top-3 left-4 bg-emerald-600 text-white text-[10px] font-bold px-2.5 py-0.5 rounded-full uppercase tracking-wider shadow-xs',
            [.text('Active Plan')],
          ),
        if (isYearly)
          span(
            classes: 'absolute -top-3 right-4 bg-amber-500 text-white text-[10px] font-bold px-2.5 py-0.5 rounded-full uppercase tracking-wider shadow-xs',
            [.text('Save 2 Months')],
          ),
        div(classes: 'flex items-center justify-between gap-4', [
          div([
            h4(classes: 'font-bold text-gray-900 text-sm sm:text-base', [
              .text(plan.name),
            ]),
            p(
              classes: 'text-xs text-gray-500 mt-0.5',
              [.text(isYearly ? 'Billed annually' : 'Billed monthly')],
            ),
          ]),
          div(classes: 'text-right shrink-0', [
            span(
              classes: 'text-lg sm:text-xl font-extrabold text-gray-900',
              [.text('₹$priceInRupees')],
            ),
            span(
              classes: 'text-xs text-gray-500 font-medium ml-0.5',
              [.text(isYearly ? '/yr' : '/mo')],
            ),
          ]),
        ]),
        if (plan.features.isNotEmpty)
          div(
            classes:
                'mt-4 pt-3.5 border-t border-border-light flex flex-col gap-2',
            [
              for (final f in plan.features)
                div(
                  classes: 'flex items-center gap-2 text-xs text-gray-600 leading-normal',
                  [
                    Check(classes: 'w-3.5 h-3.5 text-primary shrink-0'),
                    span([.text(f)]),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
