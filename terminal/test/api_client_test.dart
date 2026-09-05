import 'package:api_client/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terminal/config/api_client.dart';

void main() {
  group('Terminal API Client Configuration Tests', () {
    test('resolveApiBaseUrl returns a valid non-empty URL string', () {
      final url = resolveApiBaseUrl();
      expect(url, isNotEmpty);
      expect(url.startsWith('http://') || url.startsWith('https://'), isTrue);
    });

    test(
      'initTerminalDio configures options and web credentials correctly',
      () {
        initTerminalDio();

        expect(dio.options.baseUrl, equals(resolveApiBaseUrl()));
        expect(dio.options.connectTimeout, equals(const Duration(seconds: 10)));
        expect(dio.options.receiveTimeout, equals(const Duration(seconds: 10)));

        if (kIsWeb) {
          expect(dio.options.extra['withCredentials'], isTrue);
        } else {
          expect(dio.options.extra.containsKey('withCredentials'), isFalse);
        }
      },
    );
  });
}
