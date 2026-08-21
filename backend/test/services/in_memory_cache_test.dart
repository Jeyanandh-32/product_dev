import 'package:backend/services/cache/in_memory_cache.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryCache Tests', () {
    test('stores, retrieves, and returns null for missing key', () {
      final cache = InMemoryCache<String>()..set('k1', 'val1');

      expect(cache.get('k1'), equals('val1'));
      expect(cache.get('non_existent'), isNull);
    });

    test('expires items after ttl', () async {
      final cache = InMemoryCache<String>(
        defaultTtl: const Duration(milliseconds: 50),
      )..set('quick', 'fast');

      expect(cache.get('quick'), equals('fast'));
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(cache.get('quick'), isNull);
    });

    test('invalidates single key and prefix', () {
      final cache = InMemoryCache<int>()
        ..set('store_1:cat_1', 10)
        ..set('store_1:cat_2', 20)
        ..set('store_2:cat_1', 30)
        ..invalidate('store_1:cat_1');

      expect(cache.get('store_1:cat_1'), isNull);
      expect(cache.get('store_1:cat_2'), equals(20));

      cache.invalidatePrefix('store_1');
      expect(cache.get('store_1:cat_2'), isNull);
      expect(cache.get('store_2:cat_1'), equals(30));

      cache.clear();
      expect(cache.get('store_2:cat_1'), isNull);
    });
  });
}
