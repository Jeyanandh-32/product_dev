import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('PlatformFeeSettlement Model Tests', () {
    test('JSON serialization and deserialization of PlatformFeeSettlement', () {
      final now = DateTime.now();
      final settlement = PlatformFeeSettlement(
        id: 'settlement-123',
        merchantId: 'merchant-456',
        amountInPaise: 45000,
        ordersCount: 15,
        paymentGateway: 'phonepe',
        paymentTransactionId: 'tx-789',
        status: 'completed',
        createdAt: now,
        settledAt: now,
      );

      final json = settlement.toJson();
      expect(json['id'], 'settlement-123');
      expect(json['amountInPaise'], 45000);
      expect(json['ordersCount'], 15);

      final fromJson = PlatformFeeSettlement.fromJson(json);
      expect(fromJson.id, settlement.id);
      expect(fromJson.amountInPaise, settlement.amountInPaise);
      expect(fromJson.status, 'completed');
    });

    test(
      'JSON serialization and deserialization of MerchantPlatformFeeSummary',
      () {
        const summary = MerchantPlatformFeeSummary(
          unsettledAmountInPaise: 12500,
          unsettledOrdersCount: 4,
          recentSettlements: [],
        );

        final json = summary.toJson();
        expect(json['unsettledAmountInPaise'], 12500);
        expect(json['unsettledOrdersCount'], 4);

        final fromJson = MerchantPlatformFeeSummary.fromJson(json);
        expect(fromJson.unsettledAmountInPaise, 12500);
        expect(fromJson.unsettledOrdersCount, 4);
      },
    );
  });
}
