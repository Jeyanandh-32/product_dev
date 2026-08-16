import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/cart_signal.dart';

void main() {
  group('Terminal & Customer Cart State Tests', () {
    setUp(() {
      cartSignal.value = CartState.initial();
      discountInputSignal.value = 0.0;
      paymentModeSignal.value = PaymentMethod.cash;
    });

    final testProduct1 = Product(
      id: 'p1',
      merchantId: 'm1',
      name: 'Coffee',
      basePrice: 20.0,
      sellingPrice: 50.0, // ₹50.00
      taxRate: 5.0, // 5%
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final testProduct2 = Product(
      id: 'p2',
      merchantId: 'm1',
      name: 'Sandwich',
      basePrice: 50.0,
      sellingPrice: 120.0, // ₹120.00
      taxRate: 10.0, // 10%
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('Adding products computes correct Subtotal, Taxes, and GrandTotal in Rupees', () {
      CartController.addItem(testProduct1); // 1 Coffee = ₹50.00
      CartController.addItem(testProduct1); // 2 Coffee = ₹100.00
      CartController.addItem(testProduct2); // 1 Sandwich = ₹120.00

      final state = cartSignal.value;
      // Subtotal = 100 + 120 = ₹220.00
      expect(state.subtotal, 220.0);
      expect(state.orderQuantity, 3);
      expect(state.noOfItems, 2);

      // Tax = (100 * 0.05) + (120 * 0.10) = 5.0 + 12.0 = ₹17.00
      expect(state.taxTotal, 17.0);

      // GrandTotal = 220 + 17 = ₹237.00
      expect(state.grandTotal, 237.0);
    });

    test('Applying cart discount reduces GrandTotal correctly', () {
      CartController.addItem(testProduct1); // 1 Coffee = ₹50.00, Tax 5% = ₹2.50 -> ₹52.50
      CartController.setDiscount(10.0); // ₹10.00 discount

      final state = cartSignal.value;
      expect(state.subtotal, 50.0);
      expect(state.taxTotal, 2.5);
      expect(state.discountTotal, 10.0);
      expect(state.grandTotal, 42.5);
    });

    test('Complimentary payment mode zeroes out GrandTotal', () {
      CartController.addItem(testProduct1);
      CartController.setPaymentMode(PaymentMethod.complimentary);

      final state = cartSignal.value;
      expect(state.subtotal, 50.0);
      expect(state.taxTotal, 2.5);
      expect(state.discountTotal, 52.5);
      expect(state.grandTotal, 0.0);
    });

    test('Applying discount higher than total order amount caps at max order total', () {
      CartController.addItem(testProduct1); // 1 Coffee = ₹50.00, Tax 5% = ₹2.50 -> ₹52.50
      CartController.setDiscount(100.0); // Enter ₹100.00 (more than ₹52.50)

      final state = cartSignal.value;
      expect(state.subtotal, 50.0);
      expect(state.taxTotal, 2.5);
      expect(state.discountTotal, 52.5);
      expect(state.grandTotal, 0.0);
    });

    test('Decreasing and removing products updates cart state cleanly', () {
      CartController.addItem(testProduct1);
      CartController.addItem(testProduct1);
      expect(cartSignal.value.orderQuantity, 2);

      CartController.updateQuantity(testProduct1.id, 1);
      expect(cartSignal.value.orderQuantity, 1);
      expect(cartSignal.value.subtotal, 50.0);

      CartController.removeItem(testProduct1.id);
      expect(cartSignal.value.orderQuantity, 0);
      expect(cartSignal.value.items.isEmpty, isTrue);
      expect(cartSignal.value.grandTotal, 0.0);
    });
  });
}
