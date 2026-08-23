import 'dart:convert';
import 'dart:io';

import 'package:backend/repositories/bottle_return_dispenser_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/orders/dispense.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}
class _MockRequest extends Mock implements Request {}
class _MockDispenserHandler extends Mock implements BottleReturnDispenserHandler {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockDispenserHandler handler;

  final testOrder = Order(
    id: 'ord-123',
    merchantId: 'm-1',
    storeId: 's-1',
    orderReference: 'ORD-12345',
    billNo: 5,
    source: OrderSource.web,
    type: OrderType.takeaway,
    status: OrderStatus.completed,
    paymentStatus: PaymentStatus.completed,
    paymentMethod: PaymentMethod.upi,
    subtotal: 150,
    taxTotal: 0,
    grandTotal: 150,
    items: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    handler = _MockDispenserHandler();
    when(() => context.request).thenReturn(request);
    when(() => context.read<BottleReturnDispenserHandler>()).thenReturn(handler);
  });

  group('POST /v1/orders/dispense', () {
    test('responds with 405 Method Not Allowed for GET', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with 400 when orderReference is missing', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => <String, dynamic>{});
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with 404 when order is not found', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => {'orderReference': 'ORD-UNKNOWN'});
      when(() => handler.getDispenserOrderPayload('ORD-UNKNOWN'))
          .thenAnswer((_) async => const DispenserOrderNotFound());
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('responds with 400 when order is already completed', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => {'orderReference': 'ORD-DONE'});
      when(() => handler.getDispenserOrderPayload('ORD-DONE'))
          .thenAnswer((_) async => const DispenserOrderAlreadyCompleted());
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], contains('already been completed'));
    });

    test('returns order details without tokens for normal stores', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => {'orderReference': 'ORD-12345'});
      when(() => handler.getDispenserOrderPayload('ORD-12345'))
          .thenAnswer((_) async => DispenserOrderSuccess(order: testOrder));
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      final data = body['data'] as Map<String, dynamic>;
      expect(data['orderReference'], equals('ORD-12345'));
      expect(data.containsKey('bottleTokens'), isFalse);
    });

    test('returns order details with tokens when store has bottle return enabled', () async {
      final token = BottleQrToken(
        id: 'tok-1',
        token: 'BTL_123',
        orderId: 'ord-123',
        storeId: 's-1',
        merchantId: 'm-1',
        productId: 'p-1',
        createdAt: DateTime.now(),
      );
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => {'orderReference': 'ORD-12345'});
      when(() => handler.getDispenserOrderPayload('ORD-12345'))
          .thenAnswer((_) async => DispenserOrderSuccess(order: testOrder, bottleTokens: [token]));
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      final data = body['data'] as Map<String, dynamic>;
      expect(data['bottleTokens'], isNotNull);
      final tokens = data['bottleTokens'] as List<dynamic>;
      expect(tokens.length, equals(1));
    });
  });
}
