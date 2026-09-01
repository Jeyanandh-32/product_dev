import 'dart:convert';
import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
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

class _MockOrderItemRepository extends Mock implements OrderItemRepository {}

class _MockProductRepository extends Mock implements ProductRepository {}

class _MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockOrderRepository orderRepo;
  late _MockOrderItemRepository orderItemRepo;
  late _MockProductRepository productRepo;
  late _MockCustomerRepository customerRepo;

  const validStoreId = '11111111-1111-1111-1111-111111111111';
  const token = TokenPayload(sub: 'm-1', role: UserRole.merchant);

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    orderRepo = _MockOrderRepository();
    orderItemRepo = _MockOrderItemRepository();
    productRepo = _MockProductRepository();
    customerRepo = _MockCustomerRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(token);
    when(() => context.read<OrderRepository>()).thenReturn(orderRepo);
    when(() => context.read<OrderItemRepository>()).thenReturn(orderItemRepo);
    when(() => context.read<ProductRepository>()).thenReturn(productRepo);
    when(() => context.read<CustomerRepository>()).thenReturn(customerRepo);
  });

  test(
    '/v1/reports/dashboard GET responds with dashboard analytics map',
    () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/reports/dashboard?storeId=$validStoreId',
        ),
      );
      when(
        () => orderRepo.getDashboardAnalytics(
          merchantId: 'm-1',
          storeId: validStoreId,
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
        ),
      ).thenAnswer(
        (_) async => {
          'totalRevenue': 10000.0,
          'totalOrders': 5,
          'topProducts': <Map<String, dynamic>>[],
        },
      );

      final response = await dashboard_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      expect(data['totalOrders'], equals(5));
    },
  );

  test('/v1/reports/orders GET responds with order summary metrics and order items', () async {
    when(() => request.method).thenReturn(.get);
    when(() => request.uri).thenReturn(
      Uri.parse('http://localhost/v1/reports/orders?storeId=$validStoreId'),
    );
    when(
      () => orderRepo.count(
        merchantId: 'm-1',
        storeId: validStoreId,
        source: any(named: 'source'),
        terminalCode: any(named: 'terminalCode'),
        fromDate: any(named: 'fromDate'),
        toDate: any(named: 'toDate'),
        paymentMethod: any(named: 'paymentMethod'),
        status: any(named: 'status'),
        paymentStatus: any(named: 'paymentStatus'),
      ),
    ).thenAnswer((_) async => 10);
    when(
      () => orderRepo.getAll(
        merchantId: 'm-1',
        storeId: validStoreId,
        source: any(named: 'source'),
        terminalCode: any(named: 'terminalCode'),
        fromDate: any(named: 'fromDate'),
        toDate: any(named: 'toDate'),
        paymentMethod: any(named: 'paymentMethod'),
        status: any(named: 'status'),
        paymentStatus: any(named: 'paymentStatus'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => []);
    when(
      () => orderRepo.getOrderSummary(
        merchantId: 'm-1',
        storeId: validStoreId,
        fromDate: any(named: 'fromDate'),
        toDate: any(named: 'toDate'),
      ),
    ).thenAnswer(
      (_) async => (
        totalOrders: 10,
        grossSubtotal: 50000.0,
        totalDiscount: 500.0,
        platformFeeTotal: 0.0,
        netRevenue: 49500.0,
        cashCollected: 30000.0,
        upiCollected: 19500.0,
        walletCollected: 0.0,
        freeTotal: 0.0,
      ),
    );
    when(() => orderItemRepo.getAllForOrders(any()))
        .thenAnswer((_) async => []);
    when(() => productRepo.getByIds(any())).thenAnswer((_) async => []);
    when(() => customerRepo.getByIds(any())).thenAnswer((_) async => []);

    final response = await orders_route.onRequest(context);
    expect(response.statusCode, equals(HttpStatus.ok));
    final body = jsonDecode(await response.body()) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final summary = data['summary'] as Map<String, dynamic>;
    expect(summary['totalOrders'], equals(10));
  });

  test(
    '/v1/reports/payments GET responds with payment collection breakdown',
    () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/reports/payments?storeId=$validStoreId'),
      );
      when(
        () => orderRepo.count(
          merchantId: 'm-1',
          storeId: validStoreId,
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
          paymentMethod: any(named: 'paymentMethod'),
          paymentStatus: any(named: 'paymentStatus'),
        ),
      ).thenAnswer((_) async => 5);
      when(
        () => orderRepo.getAll(
          merchantId: 'm-1',
          storeId: validStoreId,
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
          paymentMethod: any(named: 'paymentMethod'),
          paymentStatus: any(named: 'paymentStatus'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => orderRepo.getPaymentSummary(
          merchantId: 'm-1',
          storeId: validStoreId,
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
        ),
      ).thenAnswer(
        (_) async => (
          cashCollected: 3000.0,
          upiCollected: 2000.0,
          freeTotal: 0.0,
          totalCollected: 5000.0,
        ),
      );

      final response = await payments_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
    },
  );

  test(
    '/v1/reports/profit-loss GET responds with profit & loss breakdown',
    () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/reports/profit-loss?storeId=$validStoreId',
        ),
      );
      when(
        () => orderRepo.getProfitLossReport(
          merchantId: 'm-1',
          storeId: validStoreId,
          fromDate: any(named: 'fromDate'),
          toDate: any(named: 'toDate'),
          searchQuery: any(named: 'searchQuery'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer(
        (_) async => (
          total: 0,
          items: <ProfitLossItem>[],
          totalCostPrice: 30000.0,
          totalCollectedPrice: 50000.0,
          totalProfit: 20000.0,
          totalMarginPercentage: 40.0,
        ),
      );

      final response = await profit_loss_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final summary = data['summary'] as Map<String, dynamic>;
      expect(summary['totalProfit'], equals(20000.0));
    },
  );
}
