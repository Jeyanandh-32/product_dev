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

  group('OrderRepository.getByIdOrReference', () {
    test('fetches order by id or reference with storeId param', () async {
      final mockDio = Dio();
      RequestOptions? capturedOptions;

      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        capturedOptions = options;
        return ResponseBody.fromString(
          jsonEncode({
            'status': 'success',
            'data': {
              'order': {
                'id': 'order-1',
                'merchantId': 'm-1',
                'storeId': 'store-1',
                'orderReference': 'ORD-1234',
                'billNo': 1,
                'source': 'terminal',
                'type': 'dineIn',
                'status': 'completed',
                'paymentStatus': 'paid',
                'paymentMethod': 'cash',
                'subtotal': 100.0,
                'taxTotal': 5.0,
                'grandTotal': 105.0,
                'items': <Map<String, dynamic>>[],
                'createdAt': '2026-09-19T10:00:00.000Z',
                'updatedAt': '2026-09-19T10:00:00.000Z',
              },
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final order = await OrderRepository.getByIdOrReference(
        storeId: 'store-1',
        id: 'ORD-1234',
      );

      expect(order.id, equals('order-1'));
      expect(order.orderReference, equals('ORD-1234'));
      expect(capturedOptions?.path, endsWith('/ORD-1234'));
      expect(capturedOptions?.queryParameters['storeId'], equals('store-1'));

      final aliasOrder = await OrderRepository.getById(
        storeId: 'store-1',
        id: 'ORD-1234',
      );
      expect(aliasOrder.id, equals('order-1'));
    });
  });
}
