import 'package:merchant/signals/subscription_signal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Merchant Subscription Signal State Tests', () {
    setUp(() {
      resetSubscriptionSignals();
    });

    test('resetSubscriptionSignals clears all state', () {
      final now = DateTime.now();
      subscriptionsSignal.value = {
        's-1': StoreSubscription(
          id: 'sub-1',
          storeId: 's-1',
          planCode: SubscriptionPlanCode.trial,
          status: SubscriptionStatus.trial,
          startsAt: now,
          endsAt: now.add(const Duration(days: 14)),
        ),
      };
      activeSubscriptionModalStoreSignal.value = Store(
        id: 's-1',
        name: 'Main Store',
        merchantId: 'm-1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      resetSubscriptionSignals();

      expect(subscriptionsSignal.value.isEmpty, isTrue);
      expect(activeSubscriptionModalStoreSignal.value, isNull);
      expect(subscriptionPlansSignal.value.value?.isEmpty ?? true, isTrue);
      expect(activeStoreSubscriptionDetailsSignal.value.value, isNull);
    });

    test('closeManageSubscription closes modal and resets active details', () {
      final now = DateTime.now();
      activeSubscriptionModalStoreSignal.value = Store(
        id: 's-1',
        name: 'Main Store',
        merchantId: 'm-1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      SubscriptionActions.closeManageSubscription();

      expect(activeSubscriptionModalStoreSignal.value, isNull);
      expect(activeStoreSubscriptionDetailsSignal.value.value, isNull);
    });
  });
}
