import 'package:models/models.dart';
import 'package:signals/signals.dart';

export 'subscription_actions.dart';

/// Cached store subscriptions indexed by store ID.
final subscriptionsSignal = signal<Map<String, StoreSubscription>>({});

/// Store currently being managed in the subscription modal.
final activeSubscriptionModalStoreSignal = signal<Store?>(null);

/// Available subscription plans fetched from the backend.
final subscriptionPlansSignal = asyncSignal<List<SubscriptionPlan>>(
  const AsyncData([]),
);

/// Detailed subscription information (including transaction history) for active store.
final activeStoreSubscriptionDetailsSignal =
    asyncSignal<
      ({
        StoreSubscription? subscription,
        SubscriptionPlan? plan,
        List<SubscriptionTransaction> transactions,
      })?
    >(const AsyncData(null));

/// Resets all subscription signals on logout.
void resetSubscriptionSignals() {
  subscriptionsSignal.value = {};
  activeSubscriptionModalStoreSignal.value = null;
  subscriptionPlansSignal.value = const AsyncData([]);
  activeStoreSubscriptionDetailsSignal.value = const AsyncData(null);
}
