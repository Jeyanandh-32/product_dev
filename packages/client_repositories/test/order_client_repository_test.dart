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
  group('OrderRepository.getCustomerOrders', () {
    test('forwards fromDate and toDate in query parameters', () async {
      final mockDio = Dio();
      RequestOptions? capturedOptions;

      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        capturedOptions = options;
        return ResponseBody.fromString(
          jsonEncode({
            'status': 'success',
            'data': {
              'orders': [],
              'currentPage': 1,
              'pageSize': 10,
              'totalItems': 0,
              'totalPages': 0,
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final result = await OrderRepository.getCustomerOrders(
        storeId: 'store-1',
        fromDate: '2026-09-14T18:30:00.000Z',
        toDate: '2026-09-15T18:29:59.999Z',
        page: 1,
        size: 10,
      );

      expect(result.items, isEmpty);
      expect(result.totalItems, equals(0));
      expect(capturedOptions, isNotNull);
      expect(
        capturedOptions!.queryParameters['fromDate'],
        equals('2026-09-14T18:30:00.000Z'),
      );
      expect(
        capturedOptions!.queryParameters['toDate'],
        equals('2026-09-15T18:29:59.999Z'),
      );
      expect(capturedOptions!.queryParameters['storeId'], equals('store-1'));
    });
  });
}
