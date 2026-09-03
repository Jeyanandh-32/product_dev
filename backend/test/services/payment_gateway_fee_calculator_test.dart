import 'package:backend/services/payment_gateway_fee_calculator.dart';
import 'package:test/test.dart';

void main() {
  group('PaymentGatewayFeeCalculator Tests', () {
    test('Calculates PhonePe gateway charges as 0% (Free)', () {
      final res = PaymentGatewayFeeCalculator.calculate(
        amountInPaisa: 50000,
        provider: 'phonepe',
      );

      expect(res.gatewayChargesPaise, 0);
      expect(res.percentage, 0.0);
    });

    test('Defaults to PhonePe with 0% charge when provider is omitted or null', () {
      final res = PaymentGatewayFeeCalculator.calculate(
        amountInPaisa: 10000,
      );

      expect(res.gatewayChargesPaise, 0);
      expect(res.percentage, 0.0);
    });
  });
}
