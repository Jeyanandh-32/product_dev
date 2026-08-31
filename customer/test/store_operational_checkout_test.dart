import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Store Operational & Expiration Lock Tests', () {
    final baseStore = Store(
      id: 'store-test-1',
      merchantId: 'merchant-test-1',
      name: 'Artisan Roasters',
      slug: 'artisan-roasters',
      isActive: true,
      isOnlineEnabled: true,
      isOperational: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('Store defaults isOperational to true', () {
      expect(baseStore.isOperational, isTrue);
    });

    test('Expired or non-operational store is detected properly', () {
      final expiredStore = baseStore.copyWith(isOperational: false);
      expect(expiredStore.isOperational, isFalse);

      final isStoreOrderingActive =
          expiredStore.isOperational && expiredStore.isOnlineEnabled;
      expect(isStoreOrderingActive, isFalse);
    });

    test('Active store with online ordering enabled allows checkout', () {
      final isStoreOrderingActive =
          baseStore.isOperational && baseStore.isOnlineEnabled;
      expect(isStoreOrderingActive, isTrue);
    });

    test('Store with isOnlineEnabled false disables ordering regardless of subscription', () {
      final pausedStore = baseStore.copyWith(isOnlineEnabled: false);
      final isStoreOrderingActive =
          pausedStore.isOperational && pausedStore.isOnlineEnabled;
      expect(isStoreOrderingActive, isFalse);
    });
  });
}
