import 'package:backend/services/order_calculator.dart';
import 'package:backend/services/order_reference_generator.dart';
import 'package:backend/services/phonepe_payload_builder.dart';
import 'package:backend/services/phonepe_security_helper.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('OrderCalculator Price and Tax Calculation Tests', () {
    test('Calculates exact subtotal and item totals in Paise from sellingPrice in Paise', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (productId: 'prod-1', quantity: 2, sellingPrice: 5000, taxRate: 5.0, discount: 0.0), // ₹50.00 each
          (productId: 'prod-2', quantity: 1, sellingPrice: 10000, taxRate: 18.0, discount: 10.0), // ₹100.00 with ₹10 discount
        ],
      );

      // Subtotal = (2 * 5000) + (1 * 10000) = 20000 Paise (₹200.00)
      expect(summary.subtotal, 20000);
      
      // Item 1 Tax: 5% on 10000 Paise = 500 Paise
      // Item 2 Tax: 18% on (10000 - 1000) Paise = 18% on 9000 = 1620 Paise
      // Total Tax = 500 + 1620 = 2120 Paise (₹21.20)
      expect(summary.taxTotal, 2120);

      // Grand Total = 20000 + 2120 - 0 = 22120 Paise (₹221.20)
      expect(summary.grandTotal, 22120);
      expect(summary.items.length, 2);
    });

    test('Calculates complimentary order with 100% discount', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (productId: 'prod-1', quantity: 1, sellingPrice: 5000, taxRate: 0.0, discount: 0.0),
        ],
        isComplimentary: true,
      );

      expect(summary.subtotal, 5000);
      expect(summary.taxTotal, 0);
      expect(summary.discountTotal, 5000);
      expect(summary.grandTotal, 0);
    });

    test('Applies overall order discount correctly', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (productId: 'prod-1', quantity: 1, sellingPrice: 10000, taxRate: 0.0, discount: 0.0),
        ],
        discountTotalInput: 20, // ₹20 discount = 2000 Paise
      );

      expect(summary.subtotal, 10000);
      expect(summary.discountTotal, 2000);
      expect(summary.grandTotal, 8000); // ₹80.00
    });

    test('Clamps discountTotalInput so it never exceeds subtotal plus tax', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (productId: 'prod-1', quantity: 1, sellingPrice: 5000, taxRate: 5.0, discount: 0.0),
        ],
        discountTotalInput: 100, // ₹100 discount (more than subtotal ₹50 + tax ₹2.50)
      );

      // Subtotal = 5000, Tax = 250 -> Total = 5250 Paise
      expect(summary.subtotal, 5000);
      expect(summary.taxTotal, 250);
      expect(summary.discountTotal, 5250); // Clamped to 5250 Paise
      expect(summary.grandTotal, 0);
    });
  });

  group('OrderReferenceGenerator Tests', () {
    test('Generates unique alphanumeric reference with correct prefix and format', () {
      final ref1 = OrderReferenceGenerator.generate();
      final ref2 = OrderReferenceGenerator.generate();

      expect(ref1.startsWith('ORD-'), isTrue);
      expect(ref2.startsWith('ORD-'), isTrue);
      expect(ref1, isNot(equals(ref2)));
    });
  });

  group('PhonePePayloadBuilder Tests', () {
    test('Builds valid PG checkout payload with custom metadata', () {
      final now = DateTime.now();
      final config = StorePhonePeConfig(
        id: 'cfg-1',
        storeId: 'store-1',
        createdAt: now,
        updatedAt: now,
      );

      final payload = PhonePePayloadBuilder.buildCheckoutPayload(
        config: config,
        merchantOrderId: 'ORD-12345678',
        amountInPaisa: 2500,
        redirectUrl: 'https://example.com/status',
        customerPhone: '9876543210',
        customerName: 'Jack Tester',
        storeId: 'store-1',
        customerId: 'cust-1',
      );

      expect(payload['merchantOrderId'], 'ORD-12345678');
      expect(payload['amount'], 2500);
      final paymentFlow = payload['paymentFlow'] as Map<String, dynamic>;
      final merchantUrls = paymentFlow['merchantUrls'] as Map<String, dynamic>;
      final prefill = payload['prefillUserLoginDetails'] as Map<String, dynamic>;
      final customer = payload['customerDetails'] as Map<String, dynamic>;
      final meta = payload['metaInfo'] as Map<String, dynamic>;

      expect(paymentFlow['type'], 'PG_CHECKOUT');
      expect(merchantUrls['redirectUrl'], 'https://example.com/status');
      expect(prefill['phoneNumber'], '9876543210');
      expect(customer['name'], 'Jack Tester');
      expect(meta['udf1'], 'store-1');
      expect(meta['udf2'], 'cust-1');
    });
  });

  group('PhonePeSecurityHelper Webhook HMAC Tests', () {
    test('Validates SHA-256 HMAC signature verification correctly', () {
      const secret = 'my_test_webhook_secret_key';
      const body = '{"event":"PAYMENT_SUCCESS","orderId":"ORD-123"}';
      
      expect(
        PhonePeSecurityHelper.verifyWebhookHmac(
          rawRequestBody: body,
          signatureHeader: 'invalid_signature',
          secretKey: secret,
        ),
        isFalse,
      );
    });
  });
}
