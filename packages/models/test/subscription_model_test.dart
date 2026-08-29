import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Subscription Models Tests', () {
    test('SubscriptionPlan JSON serialization and deserialization', () {
      final plan = SubscriptionPlan(
        code: SubscriptionPlanCode.monthly,
        name: 'Pro Monthly',
        priceInPaise: 29900,
        currency: 'INR',
        durationDays: 30,
        features: ['Priority support', 'Unlimited terminals'],
      );

      final json = plan.toJson();

      final reconstructed = SubscriptionPlan.fromJson(json);
      expect(reconstructed.code, SubscriptionPlanCode.monthly);
      expect(reconstructed.name, plan.name);
      expect(reconstructed.priceInPaise, plan.priceInPaise);
      expect(reconstructed.features, plan.features);
    });

    test('StoreSubscription JSON serialization and deserialization', () {
      final sub = StoreSubscription(
        id: 'sub-1',
        storeId: 'store-1',
        planCode: SubscriptionPlanCode.yearly,
        status: SubscriptionStatus.active,
        startsAt: DateTime.utc(2026, 1, 1),
        endsAt: DateTime.utc(2026, 2, 1),
        autoRenew: true,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );

      final json = sub.toJson();
      expect(json['id'], 'sub-1');
      expect(json['planCode'], 'yearly');
      expect(json['status'], 'active');
      expect(json['autoRenew'], true);

      final reconstructed = StoreSubscription.fromJson(json);
      expect(reconstructed.id, sub.id);
      expect(reconstructed.planCode, SubscriptionPlanCode.yearly);
      expect(reconstructed.status, SubscriptionStatus.active);
      expect(reconstructed.autoRenew, true);
    });

    test('SubscriptionTransaction JSON serialization and deserialization', () {
      final tx = SubscriptionTransaction(
        id: 'tx-1',
        storeId: 'store-1',
        planCode: SubscriptionPlanCode.monthly,
        amountInPaise: 299900,
        currency: 'INR',
        paymentMethod: SubscriptionPaymentMethod.simulated,
        status: PaymentStatus.completed,
        reference: 'REF-123',
        createdAt: DateTime.utc(2026, 1, 1),
      );

      final json = tx.toJson();
      expect(json['id'], 'tx-1');
      expect(json['planCode'], 'monthly');
      expect(json['paymentMethod'], 'simulated');
      expect(json['status'], 'completed');
      expect(json['amountInPaise'], 299900);

      final reconstructed = SubscriptionTransaction.fromJson(json);
      expect(reconstructed.id, tx.id);
      expect(reconstructed.planCode, SubscriptionPlanCode.monthly);
      expect(reconstructed.paymentMethod, SubscriptionPaymentMethod.simulated);
      expect(reconstructed.status, PaymentStatus.completed);
      expect(reconstructed.amountInPaise, tx.amountInPaise);
      expect(reconstructed.reference, 'REF-123');
    });
  });
}
