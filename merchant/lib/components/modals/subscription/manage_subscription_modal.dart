import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store;
import 'package:merchant/components/modals/subscription/plan_tier_card.dart';
import 'package:merchant/components/modals/subscription/renew_subscription_button.dart';
import 'package:merchant/components/modals/subscription/subscription_status_banner.dart';
import 'package:merchant/components/modals/subscription/transaction_history_table.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/subscription_signal.dart';
import 'package:models/models.dart';

/// Modal component allowing merchants to view, upgrade, and renew store subscriptions.
class ManageSubscriptionModal extends SignalComponent {
  const ManageSubscriptionModal({super.key, required this.store});

  final Store store;

  @override
  SignalState<ManageSubscriptionModal> createState() =>
      _ManageSubscriptionModalState();
}

class _ManageSubscriptionModalState
    extends SignalState<ManageSubscriptionModal> {
  SubscriptionPlanCode _selectedPlanCode = SubscriptionPlanCode.yearly;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SubscriptionActions.fetchPlans();
    SubscriptionActions.fetchStoreSubscription(component.store.id);
  }

  Future<void> _handleRenew() async {
    await SubscriptionActions.payAndRenewWithPhonePe(
      storeId: component.store.id,
      planCode: _selectedPlanCode,
      setSubmitting: (submitting) {
        if (mounted) setState(() => _isLoading = submitting);
      },
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final detailsAsync = activeStoreSubscriptionDetailsSignal.value;
    final allPlans = subscriptionPlansSignal.value.value ?? [];
    final paidPlans = allPlans
        .where((pl) => pl.code != SubscriptionPlanCode.trial)
        .toList();
    final details = detailsAsync.value;
    final sub = details?.subscription;
    final isActive = sub?.status == SubscriptionStatus.active;

    return div(
      classes: 'fixed inset-0 bg-black/40 z-50 flex items-center justify-center px-4',
      events: {'click': (_) => SubscriptionActions.closeManageSubscription()},
      [
        div(
          classes: 'bg-white w-full max-w-lg rounded-2xl shadow-xl p-6 sm:p-7 flex flex-col gap-6 max-h-[90vh] overflow-y-auto',
          events: {'click': (e) => e.stopPropagation()},
          [
            _buildHeader(),
            if (detailsAsync.isLoading && details == null)
              _buildLoading()
            else ...[
              SubscriptionStatusBanner(subscription: sub, plan: details?.plan),
              _buildPlanSelector(paidPlans, sub, isActive),
              RenewSubscriptionButton(
                selectedPlanCode: _selectedPlanCode,
                subscription: sub,
                isLoading: _isLoading,
                onRenew: _handleRenew,
              ),
              TransactionHistoryTable(
                transactions: details?.transactions ?? [],
              ),
            ],
          ],
        ),
      ],
    );
  }

  Component _buildLoading() => div(
    classes: 'py-12 flex flex-col items-center justify-center gap-3 text-center text-sm text-gray-500 font-medium',
    [
      span(classes: 'loading loading-spinner loading-md text-primary', []),
      .text('Loading subscription details...'),
    ],
  );

  Component _buildHeader() =>
      div(classes: 'flex justify-between items-center', [
        div([
          h2(classes: 'text-lg font-bold text-gray-900', [
            .text('Manage Subscription'),
          ]),
          p(classes: 'text-xs text-gray-500 font-medium mt-0.5', [
            .text('Store: ${component.store.name}'),
          ]),
        ]),
        button(
          onClick: SubscriptionActions.closeManageSubscription,
          classes: 'border border-border-light p-1.5 rounded-full hover:bg-gray-50 cursor-pointer text-gray-400 hover:text-gray-600',
          [X(classes: 'w-4 h-4')],
        ),
      ]);

  Component _buildPlanSelector(
    List<SubscriptionPlan> plans,
    StoreSubscription? sub,
    bool isActive,
  ) => div(
    classes: 'flex flex-col gap-3',
    [
      h4(classes: 'text-xs font-bold uppercase tracking-wider text-gray-500', [
        .text('Choose a Subscription Plan'),
      ]),
      div(
        classes: 'flex flex-col gap-3.5 pt-1',
        [
          for (final plan in plans)
            PlanTierCard(
              plan: plan,
              isSelected: _selectedPlanCode == plan.code,
              isCurrentPlan: isActive && sub?.planCode == plan.code,
              onSelect: () => setState(() => _selectedPlanCode = plan.code),
            ),
        ],
      ),
    ],
  );
}
