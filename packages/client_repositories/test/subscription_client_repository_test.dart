import 'dart:convert';
import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
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
  group('SubscriptionClientRepository Unit Tests', () {
    test('getPlans parses and returns list of subscription plans', () async {
      final mockDio = Dio();
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'data': {
              'plans': [
                {
                  'id': 'plan-1',
                  'code': 'yearly',
                  'name': 'Pro Yearly',
                  'priceInPaise': 299900,
                  'currency': 'INR',
                  'durationDays': 365,
                  'features': ['Unlimited Invoices'],
                },
              ],
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final plans = await SubscriptionClientRepository.getPlans();
      expect(plans.length, equals(1));
      expect(plans.first.code, equals(SubscriptionPlanCode.yearly));
      expect(plans.first.name, equals('Pro Yearly'));
    });

    test('getStoreSubscription parses subscription and transaction records', () async {
      final now = DateTime.now().toIso8601String();
      final mockDio = Dio();
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'data': {
              'subscription': {
                'id': 'sub-1',
                'storeId': 'store-1',
                'planCode': 'yearly',
                'status': 'active',
                'startsAt': now,
                'endsAt': now,
              },
              'plan': {
                'id': 'plan-1',
                'code': 'yearly',
                'name': 'Pro Yearly',
                'priceInPaise': 299900,
                'currency': 'INR',
                'durationDays': 365,
                'features': [],
              },
              'transactions': [
                {
                  'id': 'tx-1',
                  'storeId': 'store-1',
                  'planCode': 'yearly',
                  'amountInPaise': 299900,
                  'currency': 'INR',
                  'paymentMethod': 'phonepe',
                  'status': 'completed',
                },
              ],
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final details = await SubscriptionClientRepository.getStoreSubscription('store-1');
      expect(details.subscription?.storeId, equals('store-1'));
      expect(details.plan?.code, equals(SubscriptionPlanCode.yearly));
      expect(details.transactions.length, equals(1));
    });

    test('initiateSubscriptionPayment returns session with tokenUrl', () async {
      final mockDio = Dio();
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'data': {
              'storeId': 'store-1',
              'planCode': 'yearly',
              'merchantTransactionId': 'SUB_TX_123',
              'amountInPaise': 299900,
              'tokenUrl': 'https://mercury.phonepe.com/transact/test',
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      initDio(mockDio);

      final session = await SubscriptionClientRepository.initiateSubscriptionPayment(
        storeId: 'store-1',
        planCode: SubscriptionPlanCode.yearly,
      );
      expect(session.merchantTransactionId, equals('SUB_TX_123'));
      expect(session.tokenUrl, contains('phonepe.com'));
    });

    test('verifySubscriptionPayment returns renewed subscription on success', () async {
      final now = DateTime.now().toIso8601String();
      final mockDio = Dio();
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'data': {
              'subscription': {
                'id': 'sub-1',
                'storeId': 'store-1',
                'planCode': 'yearly',
                'status': 'active',
                'startsAt': now,
                'endsAt': now,
              },
              'plan': {
                'id': 'plan-1',
                'code': 'yearly',
                'name': 'Pro Yearly',
                'priceInPaise': 299900,
                'currency': 'INR',
                'durationDays': 365,
                'features': [],
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

      final result = await SubscriptionClientRepository.verifySubscriptionPayment(
        storeId: 'store-1',
        merchantTransactionId: 'SUB_TX_123',
      );
      expect(result.subscription.status, equals(SubscriptionStatus.active));
      expect(result.plan.code, equals(SubscriptionPlanCode.yearly));
    });
  });
}
