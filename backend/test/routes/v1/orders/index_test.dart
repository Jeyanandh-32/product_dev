import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/services/order_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/orders/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockOrderService extends Mock implements OrderService {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockOrderService orderService;

  const testMerchantId = 'm-1';
  const testStoreId = '11111111-1111-1111-1111-111111111111';
  const testProductId = '22222222-2222-2222-2222-222222222222';
  const tokenPayload = TokenPayload(
    sub: testMerchantId,
    role: UserRole.terminal,
    terminalCode: 'TERM01',
  );

  setUpAll(() {
    registerFallbackValue(OrderSource.terminal);
    registerFallbackValue(OrderType.dineIn);
    registerFallbackValue(PaymentMethod.cash);
    registerFallbackValue(OrderStatus.completed);
    registerFallbackValue(PaymentStatus.completed);
  });

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();
    orderService = _MockOrderService();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(tokenPayload);
    when(() => context.read<OrderService>()).thenReturn(orderService);
  });

  group('POST /v1/orders', () {
    test('responds with 400 when storeId is missing from query parameters', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/orders'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Store ID is required.'));
    });

    test('responds with 400 when storeId is not a valid UUID', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/orders?storeId=not-a-uuid'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid store id.'));
    });

    test('responds with 400 when body is invalid JSON', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/orders?storeId=$testStoreId'),
      );
      when(() => request.json()).thenThrow(const FormatException('Malformed JSON'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with 400 when products list is missing or empty', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/orders?storeId=$testStoreId'),
      );
      when(() => request.json()).thenAnswer((_) async => {'products': <dynamic>[]});

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], contains('Products list'));
    });

    test('responds with 200 and completed order on valid checkout', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/orders?storeId=$testStoreId'),
      );

      final orderInputJson = {
        'products': [
          {
            'productId': testProductId,
            'quantity': 2,
            'discount': 5.0,
          }
        ],
        'source': 'terminal',
        'type': 'dineIn',
        'paymentMethod': 'cash',
        'discountTotal': 10.0,
      };
      when(() => request.json()).thenAnswer((_) async => orderInputJson);

      final now = DateTime.now();
      final expectedOrder = Order(
        id: 'ord-123',
        merchantId: testMerchantId,
        storeId: testStoreId,
        orderReference: 'ORD-12345678',
        billNo: 42,
        source: OrderSource.terminal,
        type: OrderType.dineIn,
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.completed,
        paymentMethod: PaymentMethod.cash,
        subtotal: 100,
        discountTotal: 10,
        taxTotal: 5,
        grandTotal: 95,
        terminalCode: 'TERM01',
        items: const [
          OrderItem(
            id: 'item-1',
            productId: testProductId,
            product: null,
            storeId: testStoreId,
            quantity: 2,
            unitPrice: 50,
            taxRate: 5,
            discount: 5,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      when(
        () => orderService.checkout(
          merchantId: testMerchantId,
          storeId: testStoreId,
          productsInput: [
            {
              'productId': testProductId,
              'quantity': 2,
              'discount': 5.0,
            }
          ],
          source: OrderSource.terminal,
          type: OrderType.dineIn,
          paymentMethod: PaymentMethod.cash,
          discountTotalInput: 10,
          terminalCode: 'TERM01',
        ),
      ).thenAnswer((_) async => expectedOrder);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));

      final data = body['data'] as Map<String, dynamic>;
      final orderData = data['order'] as Map<String, dynamic>;
      expect(orderData['id'], equals('ord-123'));
      expect(orderData['grandTotal'], equals(95.0));
      expect(orderData['billNo'], equals(42));

      verify(
        () => orderService.checkout(
          merchantId: testMerchantId,
          storeId: testStoreId,
          productsInput: any(named: 'productsInput'),
          source: OrderSource.terminal,
          type: OrderType.dineIn,
          paymentMethod: PaymentMethod.cash,
          discountTotalInput: 10,
          terminalCode: 'TERM01',
        ),
      ).called(1);
    });

    test('responds with 500 when orderService throws unexpected exception', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/orders?storeId=$testStoreId'),
      );

      final orderInputJson = {
        'products': [
          {
            'productId': testProductId,
            'quantity': 1,
          }
        ],
      };
      when(() => request.json()).thenAnswer((_) async => orderInputJson);

      when(
        () => orderService.checkout(
          merchantId: any(named: 'merchantId'),
          storeId: any(named: 'storeId'),
          productsInput: any(named: 'productsInput'),
          source: any(named: 'source'),
          type: any(named: 'type'),
          paymentMethod: any(named: 'paymentMethod'),
          discountTotalInput: any(named: 'discountTotalInput'),
          terminalCode: any(named: 'terminalCode'),
        ),
      ).thenThrow(Exception('Stock allocation failed'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.internalServerError));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
    });
  });

  group('GET /v1/orders', () {
    test('responds with 400 for GET when storeId is missing', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/orders'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });

  group('unsupported methods', () {
    test('responds with 405 for PUT', () async {
      when(() => request.method).thenReturn(.put);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with 405 for DELETE', () async {
      when(() => request.method).thenReturn(.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
