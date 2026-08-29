import 'package:backend/services/order_calculator.dart';
import 'package:test/test.dart';

void main() {
  group('OrderCalculator Online Platform Fee Tests', () {
    test('POS orders have zero platform fee', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (
            productId: 'prod-1',
            quantity: 2,
            sellingPrice: 5000,
            taxRate: 0.0,
            discount: 0.0,
          ),
        ],
      );

      expect(summary.grandTotal, 10000);
      expect(summary.platformFee, 0);
    });

    test('Online web orders apply 1.99% platform fee on grand total', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (
            productId: 'prod-1',
            quantity: 1,
            sellingPrice: 100000,
            taxRate: 0.0,
            discount: 0.0,
          ), // ₹1,000.00
        ],
        isOnline: true,
      );

      expect(summary.grandTotal, 100000);
      // 1.99% of 100000 Paise = 1990 Paise (₹19.90)
      expect(summary.platformFee, 1990);
    });

    test('Online web orders with discounts calculate 1.99% on discounted grand total', () {
      final summary = OrderCalculator.calculate(
        lineItems: [
          (
            productId: 'prod-1',
            quantity: 2,
            sellingPrice: 5000,
            taxRate: 0.0,
            discount: 0.0,
          ), // ₹100.00
        ],
        discountTotalInput:
            20, // ₹20.00 discount -> Grand Total = ₹80.00 (8000 Paise)
        isOnline: true,
      );

      expect(summary.grandTotal, 8000);
      // 1.99% of 8000 Paise = 159.2 -> 159 Paise (₹1.59)
      expect(summary.platformFee, 159);
    });
  });
}
