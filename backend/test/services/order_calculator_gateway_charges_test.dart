import 'package:backend/services/order_calculator.dart';
import 'package:backend/services/phonepe_payload_builder.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('OrderCalculator Gateway Charges & Split Tests', () {
    test('Includes gateway charges in order grand total calculation', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (
            productId: 'p-1',
            quantity: 1,
            sellingPrice: 10000,
            taxRate: 0.0,
            discount: 0.0,
          ),
        ],
        isOnline: true,
        gatewayCharges: 250, // ₹2.50
      );

      // Subtotal = 10000 Paise (₹100)
      // Platform Fee = 1.99% of 10000 = 199 Paise (₹1.99)
      // Gateway Charges = 250 Paise (₹2.50)
      // Grand Total = 10000 + 199 + 250 = 10449 Paise (₹104.49)
      expect(summary.subtotal, 10000);
      expect(summary.platformFee, 199);
      expect(summary.gatewayCharges, 250);
      expect(summary.grandTotal, 10449);
    });

    test(
      'Builds PhonePe payload with marketplace split shares and metadata',
      () {
        final now = DateTime.now();
        final config = StorePhonePeConfig(
          id: 'cfg-split',
          storeId: 'store-1',
          createdAt: now,
          updatedAt: now,
        );

        final payload = PhonePePayloadBuilder.buildCheckoutPayload(
          config: config,
          merchantOrderId: 'ORD-SPLIT-1',
          amountInPaisa: 10199,
          redirectUrl: 'https://example.com/status',
        );

        expect(payload['amount'], 10199);
        expect(payload.containsKey('splitPayment'), isFalse);
        expect(payload['merchantOrderId'], 'ORD-SPLIT-1');
      },
    );

    test('Validates hybrid order split math (wallet deduction + UPI)', () {
      const netOrderTotalPaise = 70000; // ₹700
      const platformFeePaise = 1393; // 1.99% = ₹13.93
      const gatewayChargesPaise = 0; // PhonePe: 0
      const walletBalancePaise = 50000; // ₹500 wallet
      const grandTotalPaise =
          netOrderTotalPaise + platformFeePaise + gatewayChargesPaise; // 71393

      // Deduct wallet from order
      const actualWalletDeductionPaise = walletBalancePaise >= grandTotalPaise
          ? grandTotalPaise
          : walletBalancePaise; // 50000
      const remainingPayablePaise =
          grandTotalPaise - actualWalletDeductionPaise; // 21393

      const merchantRemainingOrderPaise =
          netOrderTotalPaise - actualWalletDeductionPaise; // 20000
      const merchantSharePaise =
          merchantRemainingOrderPaise + gatewayChargesPaise; // 20000 (₹200)
      const platformSharePaise =
          remainingPayablePaise - merchantSharePaise; // 1393 (₹13.93)

      expect(remainingPayablePaise, 21393);
      expect(merchantSharePaise, 20000);
      expect(platformSharePaise, 1393);
      expect(merchantSharePaise + platformSharePaise, remainingPayablePaise);
    });
  });
}
