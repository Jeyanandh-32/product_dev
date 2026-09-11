import 'package:customer/config/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('Customer API Client URL Resolution Tests', () {
    test('resolveCustomerApiBaseUrl returns valid default fallback when not in browser', () {
      final url = resolveCustomerApiBaseUrl();
      expect(url, isNotEmpty);
      expect(url.startsWith('http://') || url.startsWith('https://'), isTrue);
    });
  });
}
