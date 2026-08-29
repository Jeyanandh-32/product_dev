import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store;
import 'package:merchant/components/modals/subscription/plan_tier_card.dart';
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
    setState(() => _isLoading = true);
    final ok = await SubscriptionActions.renewSubscription(
      storeId: component.store.id,
      planCode: _selectedPlanCode,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (ok) SubscriptionActions.closeManageSubscription();
    }
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
    final isBlocked = isActive && sub?.planCode == _selectedPlanCode;

    return div(
      classes: 'fixed inset-0 bg-black/40 z-50 flex items-center justify-center px-4',
      events: {'click': (_) => SubscriptionActions.closeManageSubscription()},
      [
        div(
          classes: 'bg-white w-full max-w-lg rounded-2xl shadow-xl p-6 flex flex-col gap-5 max-h-[90vh] overflow-y-auto',
          events: {'click': (e) => e.stopPropagation()},
          [
            _buildHeader(),
            if (detailsAsync.isLoading && details == null)
              _buildLoading()
            else ...[
              SubscriptionStatusBanner(subscription: sub, plan: details?.plan),
              _buildPlanSelector(paidPlans, sub, isActive),
              _buildRenewButton(sub, isBlocked),
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
          p(classes: 'text-xs text-gray-500 font-medium', [
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
    classes: 'space-y-2.5',
    [
      h4(classes: 'text-xs font-bold uppercase tracking-wider text-gray-500', [
        .text('Choose a Subscription Plan'),
      ]),
      for (final plan in plans)
        PlanTierCard(
          plan: plan,
          isSelected: _selectedPlanCode == plan.code,
          isCurrentPlan: isActive && sub?.planCode == plan.code,
          onSelect: () => setState(() => _selectedPlanCode = plan.code),
        ),
    ],
  );

  Component _buildRenewButton(StoreSubscription? sub, bool isBlocked) {
    final isYearly = _selectedPlanCode == SubscriptionPlanCode.yearly;
    final planTitle = isYearly ? 'Yearly' : 'Monthly';
    final txt = _isLoading
        ? 'Processing...'
        : isBlocked
        ? 'Current Active Plan'
        : (sub?.status == SubscriptionStatus.gracePeriod ||
              sub?.status == SubscriptionStatus.expired)
        ? 'Renew $planTitle Plan'
        : sub?.planCode == SubscriptionPlanCode.monthly && isYearly
        ? 'Upgrade to Yearly Plan'
        : sub?.planCode == SubscriptionPlanCode.trial || sub == null
        ? 'Activate $planTitle Plan'
        : 'Switch to $planTitle Plan';

    final cls = isBlocked || _isLoading
        ? 'w-full py-3 px-4 rounded-xl font-bold text-sm bg-gray-200 text-gray-400 cursor-not-allowed flex items-center justify-center gap-2'
        : 'w-full py-3 px-4 rounded-xl font-bold text-sm bg-primary text-white hover:bg-primary-hover transition-all flex items-center justify-center gap-2 cursor-pointer';

    return button(
      type: .button,
      onClick: (isBlocked || _isLoading) ? null : _handleRenew,
      classes: cls,
      [
        if (_isLoading)
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
