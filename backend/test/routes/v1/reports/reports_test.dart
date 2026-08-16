import 'dart:convert';
import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/reports/dashboard.dart' as dashboard_route;
import '../../../../routes/v1/reports/orders.dart' as orders_route;
import '../../../../routes/v1/reports/payments.dart' as payments_route;
import '../../../../routes/v1/reports/profit-loss.dart' as profit_loss_route;

class _MockRequestContext extends Mock implements RequestContext {}
class _MockRequest extends Mock implements Request {}
class _MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockOrderRepository orderRepo;

  const validStoreId = '11111111-1111-1111-1111-111111111111';
  const token = TokenPayload(sub: 'm-1', role: UserRole.merchant);

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    orderRepo = _MockOrderRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(token);
    when(() => context.read<OrderRepository>()).thenReturn(orderRepo);
  });

  group('/v1/reports/dashboard', () {
    test('GET responds with dashboard analytics map', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/reports/dashboard?storeId=$validStoreId'));

      when(() => orderRepo.getDashboardAnalytics(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          )).thenAnswer((_) async => {
            'totalRevenue': 10000.0,
            'totalOrders': 5,
            'topProducts': <Map<String, dynamic>>[],
          });

      final response = await dashboard_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      expect(data['totalOrders'], equals(5));
    });
  });

  group('/v1/reports/orders', () {
    test('GET responds with order summary metrics', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/reports/orders?storeId=$validStoreId'));

      when(() => orderRepo.count(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
            paymentMethod: any(named: 'paymentMethod'),
            status: any(named: 'status'),
            paymentStatus: any(named: 'paymentStatus'),
          )).thenAnswer((_) async => 10);

      when(() => orderRepo.getAll(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
            paymentMethod: any(named: 'paymentMethod'),
            status: any(named: 'status'),
            paymentStatus: any(named: 'paymentStatus'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => []);

      when(() => orderRepo.getOrderSummary(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          )).thenAnswer((_) async => (
            totalOrders: 10,
            grossSubtotal: 50000.0,
            totalDiscount: 500.0,
            netRevenue: 49500.0,
            cashCollected: 30000.0,
            upiCollected: 19500.0,
            walletCollected: 0.0,
            freeTotal: 0.0,
          ));

      final response = await orders_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final summary = data['summary'] as Map<String, dynamic>;
      expect(summary['totalOrders'], equals(10));
    });
  });

  group('/v1/reports/payments', () {
    test('GET responds with payment collection breakdown', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/reports/payments?storeId=$validStoreId'));

      when(() => orderRepo.count(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
            paymentMethod: any(named: 'paymentMethod'),
            paymentStatus: any(named: 'paymentStatus'),
          )).thenAnswer((_) async => 5);

      when(() => orderRepo.getAll(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
            paymentMethod: any(named: 'paymentMethod'),
            paymentStatus: any(named: 'paymentStatus'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => []);

      when(() => orderRepo.getPaymentSummary(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
          )).thenAnswer((_) async => (
            cashCollected: 2000.0,
            upiCollected: 3000.0,
            freeTotal: 0.0,
            totalCollected: 5000.0,
          ));

      final response = await payments_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final summary = data['summary'] as Map<String, dynamic>;
      expect(summary['totalCollected'], equals(5000.0));
    });
  });

  group('/v1/reports/profit-loss', () {
    test('GET responds with profit and loss report data', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/reports/profit-loss?storeId=$validStoreId'));

      when(() => orderRepo.getProfitLossReport(
            merchantId: 'm-1',
            storeId: validStoreId,
            fromDate: any(named: 'fromDate'),
            toDate: any(named: 'toDate'),
            searchQuery: any(named: 'searchQuery'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => (
            total: 1,
            items: <ProfitLossItem>[],
            totalCostPrice: 2000.0,
            totalCollectedPrice: 5000.0,
            totalProfit: 3000.0,
            totalMarginPercentage: 60.0,
          ));

      final response = await profit_loss_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final summary = data['summary'] as Map<String, dynamic>;
      expect(summary['totalProfit'], equals(3000.0));
    });
  });
}
