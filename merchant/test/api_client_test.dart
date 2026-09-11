import 'package:merchant/config/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('Merchant API Client URL Resolution Tests', () {
    test('resolveMerchantApiBaseUrl returns valid default fallback when not in browser', () {
      final url = resolveMerchantApiBaseUrl();
      expect(url, isNotEmpty);
      expect(url.startsWith('http://') || url.startsWith('https://'), isTrue);
    });
  });
}
