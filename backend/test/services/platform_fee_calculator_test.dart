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

    test('Online web orders apply 1.99% platform fee added to customer grand total', () {
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

      // 1.99% of 100000 Paise = 1990 Paise (₹19.90)
      expect(summary.platformFee, 1990);
      expect(summary.grandTotal, 101990);
    });

    test('Online web orders with discounts calculate 1.99% and add to customer grand total', () {
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
            20, // ₹20.00 discount -> Net Total = ₹80.00 (8000 Paise)
        isOnline: true,
      );

      // 1.99% of 8000 Paise = 159.2 -> 159 Paise (₹1.59)
      expect(summary.platformFee, 159);
      expect(summary.grandTotal, 8159);
    });
  });
}
