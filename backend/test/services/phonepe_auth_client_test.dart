import 'dart:convert';
import 'dart:typed_data';

import 'package:backend/services/phonepe_auth_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockAdapter implements HttpClientAdapter {
  _MockAdapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => handler(options);

  @override
  void close({bool force = false}) {}
}

void main() {
  group('PhonePeAuthClient Unit Tests', () {
    test('getAuthBaseUrl returns correct URL per environment', () {
      final client = PhonePeAuthClient();
      expect(
        client.getAuthBaseUrl(PaymentGatewayEnv.uat),
        equals('https://api-preprod.phonepe.com/apis/pg-sandbox'),
      );
      expect(
        client.getAuthBaseUrl(PaymentGatewayEnv.prod),
        equals('https://api.phonepe.com/apis/identity-manager'),
      );
    });

    test('getAuthToken returns null when credentials missing', () async {
      final client = PhonePeAuthClient();
      final now = DateTime.now();
      final config = StorePhonePeConfig(
        id: 'cfg-1',
        storeId: 'store-1',
        createdAt: now,
        updatedAt: now,
      );

      final token = await client.getAuthToken(config);
      expect(token, isNull);
    });

    test('getAuthToken requests token and returns access_token', () async {
      final mockDio = Dio()
        ..httpClientAdapter = _MockAdapter((options) {
          return ResponseBody.fromString(
            jsonEncode({'access_token': 'test_oauth_token_123'}),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

      final client = PhonePeAuthClient(dio: mockDio);
      final now = DateTime.now();
      final config = StorePhonePeConfig(
        id: 'cfg-1',
        storeId: 'store-1',
        clientId: 'client_id_val',
        clientSecret: 'client_secret_val',
        clientVersion: '1',
        createdAt: now,
        updatedAt: now,
      );

      final token = await client.getAuthToken(config);
      expect(token, equals('test_oauth_token_123'));
    });
  });
}
