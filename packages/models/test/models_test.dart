import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Product Model Tests', () {
    test('can be instantiated with correct values', () {
      final now = DateTime.now();
      final product = Product(
        id: 'test-id',
        merchantId: 'merchant-id',
        name: 'Test Product',
        taxRate: 5.0,
        basePrice: 100,
        sellingPrice: 120,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(product.id, equals('test-id'));
      expect(product.name, equals('Test Product'));
      expect(product.basePrice, equals(100));
      expect(product.sellingPrice, equals(120));
    });
  });
}
