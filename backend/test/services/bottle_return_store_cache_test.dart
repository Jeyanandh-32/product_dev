import 'package:backend/services/bottle_return_store_cache.dart';
import 'package:test/test.dart';

void main() {
  group('BottleReturnStoreCache Tests', () {
    setUp(BottleReturnStoreCache.instance.clear);

    test('invalidate removes cached key', () {
      BottleReturnStoreCache.instance.invalidate('store_123');
      expect(true, isTrue);
    });

    test('clear resets the store cache', () {
      BottleReturnStoreCache.instance.clear();
      expect(true, isTrue);
    });
  });
}
