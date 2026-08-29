import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

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

/// Actions for fetching and renewing subscriptions.
abstract final class SubscriptionActions {
  /// Fetches available subscription plans.
  static Future<void> fetchPlans() async {
    try {
      final plans = await SubscriptionClientRepository.getPlans();
      subscriptionPlansSignal.value = AsyncData(plans);
    } catch (_) {}
  }

  /// Fetches store subscription details.
  static Future<void> fetchStoreSubscription(
    String storeId, {
    bool silent = false,
  }) async {
    try {
      final details = await SubscriptionClientRepository.getStoreSubscription(
        storeId,
      );
      activeStoreSubscriptionDetailsSignal.value = AsyncData(details);
      if (details.subscription != null) {
        subscriptionsSignal.value = {
          ...subscriptionsSignal.value,
          storeId: details.subscription!,
        };
      }
    } catch (e) {
      if (!silent) {
        final message = e is ApiException
            ? e.message
            : 'Failed to load subscription.';
        showToast(message);
      }
    }
  }

  /// Fetches subscriptions for multiple stores in batch.
  static Future<void> fetchSubscriptionsForStores(List<Store> stores) async {
    await Future.wait(
      stores.map((s) => fetchStoreSubscription(s.id, silent: true)),
    );
  }

  /// Opens the subscription management modal for [store].
  static Future<void> openManageSubscription(Store store) async {
    activeSubscriptionModalStoreSignal.value = store;
    activeStoreSubscriptionDetailsSignal.value = const AsyncLoading();
    await Future.wait([
      fetchPlans(),
      fetchStoreSubscription(store.id),
    ]);
  }

  /// Closes the subscription modal.
  static void closeManageSubscription() {
    activeSubscriptionModalStoreSignal.value = null;
    activeStoreSubscriptionDetailsSignal.value = const AsyncData(null);
  }

  /// Renews or upgrades the subscription for the given store.
  static Future<bool> renewSubscription({
    required String storeId,
    required SubscriptionPlanCode planCode,
    SubscriptionPaymentMethod paymentMethod =
        SubscriptionPaymentMethod.simulated,
  }) async {
    try {
      final result = await SubscriptionClientRepository.renewSubscription(
        storeId: storeId,
        planCode: planCode,
        paymentMethod: paymentMethod,
      );

      subscriptionsSignal.value = {
        ...subscriptionsSignal.value,
        storeId: result.subscription,
      };

      showToast(
        'Subscription activated successfully!',
        type: ToastType.success,
      );
      await fetchStoreSubscription(storeId);
      return true;
    } catch (e) {
      final message = e is ApiException
          ? e.message
          : 'Subscription renewal failed.';
      showToast(message);
      return false;
    }
  }
}
