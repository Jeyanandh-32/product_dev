import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

class _MockHttpClientAdapter implements HttpClientAdapter {
  _MockHttpClientAdapter(this.handler);

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
  group('PlatformFeeClientRepository Unit Tests', () {
    test('getSummary parses and returns platform fee summary', () async {
      final mockDio = Dio();
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        expect(options.path, equals(ApiEndpoints.merchantPlatformFees));
        return ResponseBody.fromString(
          jsonEncode({
            'status': 'success',
            'data': {
              'unsettledAmountInPaise': 3550,
              'unsettledOrdersCount': 3,
              'recentSettlements': [],
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final summary = await PlatformFeeClientRepository.getSummary();
      expect(summary.unsettledAmountInPaise, equals(3550));
      expect(summary.unsettledOrdersCount, equals(3));
    });

    test('initiatePayment returns tokenUrl on success', () async {
      final mockDio = Dio();
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        expect(
          options.path,
          equals(ApiEndpoints.merchantPlatformFeesInitiatePayment),
        );
        return ResponseBody.fromString(
          jsonEncode({
            'status': 'success',
            'data': {
              'tokenUrl': 'https://mercury-uat.phonepe.com/transact?token=123',
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final tokenUrl = await PlatformFeeClientRepository.initiatePayment();
      expect(tokenUrl, contains('phonepe.com'));
    });

    test('verifyPayment returns updated summary on success', () async {
      final mockDio = Dio();
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        expect(
          options.path,
          equals(ApiEndpoints.merchantPlatformFeesVerifyPayment),
        );
        return ResponseBody.fromString(
          jsonEncode({
            'status': 'success',
            'data': {
              'unsettledAmountInPaise': 0,
              'unsettledOrdersCount': 0,
              'recentSettlements': [],
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final summary = await PlatformFeeClientRepository.verifyPayment();
      expect(summary.unsettledAmountInPaise, equals(0));
      expect(summary.unsettledOrdersCount, equals(0));
    });
  });
}
