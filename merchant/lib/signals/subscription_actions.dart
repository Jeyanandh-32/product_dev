import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/subscription_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:merchant/utils/phonepe_interop.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Actions for fetching, paying, and renewing subscriptions.
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
      if (details.subscription case final sub?) {
        subscriptionsSignal.value = {
          ...subscriptionsSignal.value,
          storeId: sub,
        };
      }
    } on ApiException catch (e) {
      if (!silent) showToast(e.message);
    } catch (_) {
      if (!silent) showToast('Failed to load subscription.');
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
    await Future.wait([fetchPlans(), fetchStoreSubscription(store.id)]);
  }

  /// Closes the subscription modal.
  static void closeManageSubscription() {
    activeSubscriptionModalStoreSignal.value = null;
    activeStoreSubscriptionDetailsSignal.value = const AsyncData(null);
  }

  /// Initiates payment session and opens checkout modal for subscription renewal.
  static Future<void> payAndRenewWithPhonePe({
    required String storeId,
    required SubscriptionPlanCode planCode,
    required void Function(bool isSubmitting) setSubmitting,
  }) async {
    setSubmitting(true);
    try {
      final session =
          await SubscriptionClientRepository.initiateSubscriptionPayment(
            storeId: storeId,
            planCode: planCode,
          );

      openPhonePeCheckoutModal(
        tokenUrl: session.tokenUrl,
        onComplete: (status) async {
          if (PhonePeGatewayState.fromJson(status)?.isConcluded ?? false) {
            try {
              final result =
                  await SubscriptionClientRepository.verifySubscriptionPayment(
                    storeId: storeId,
                    merchantTransactionId: session.merchantTransactionId,
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
            } on ApiException catch (e) {
              showToast(e.message);
            } catch (_) {
              showToast('Verification failed');
            }
          } else {
            showToast('Subscription payment cancelled.', type: ToastType.warning);
          }
          setSubmitting(false);
        },
      );
    } on ApiException catch (e) {
      setSubmitting(false);
      showToast(e.message.isEmpty ? 'Failed to initiate payment.' : e.message);
    } catch (_) {
      setSubmitting(false);
      showToast('Failed to initiate payment.');
    }
  }

  /// Renews or upgrades the subscription for the given store with simulated or other payment.
  static Future<bool> renewSubscription({
    required String storeId,
    required SubscriptionPlanCode planCode,
    SubscriptionPaymentMethod paymentMethod = SubscriptionPaymentMethod.simulated,
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
      showToast('Subscription activated successfully!', type: ToastType.success);
      await fetchStoreSubscription(storeId);
      return true;
    } on ApiException catch (e) {
      showToast(e.message);
      return false;
    } catch (_) {
      showToast('Subscription renewal failed.');
      return false;
    }
  }
}
