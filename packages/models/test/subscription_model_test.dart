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

    test(
      'SubscriptionPaymentSession JSON serialization and deserialization',
      () {
        final session = SubscriptionPaymentSession(
          storeId: 'store-1',
          planCode: 'monthly',
          merchantTransactionId: 'SUB_1_123',
          amountInPaise: 29900,
          tokenUrl: 'https://phonepe.com/pay',
        );

        final json = session.toJson();
        expect(json['storeId'], 'store-1');
        expect(json['merchantTransactionId'], 'SUB_1_123');

        final reconstructed = SubscriptionPaymentSession.fromJson(json);
        expect(reconstructed.storeId, session.storeId);
        expect(
          reconstructed.merchantTransactionId,
          session.merchantTransactionId,
        );
        expect(reconstructed.tokenUrl, session.tokenUrl);
      },
    );

    test('PlatformPhonePeConfig model and adapter conversion', () {
      final config = PlatformPhonePeConfig(
        id: 'cfg-1',
        isEnabled: true,
        env: PaymentGatewayEnv.uat,
        clientId: 'PGTESTPAYUAT',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );

      final storeConfig = config.toStorePhonePeConfig(storeId: 'store-1');
      expect(storeConfig.id, 'cfg-1');
      expect(storeConfig.storeId, 'store-1');
      expect(storeConfig.clientId, 'PGTESTPAYUAT');
      expect(storeConfig.enableCards, isTrue);
    });
  });
}
