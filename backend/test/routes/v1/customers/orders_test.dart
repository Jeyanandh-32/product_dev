import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/customers/orders.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockOrderRepository orderRepo;

  const testCustomerId = 'cust-1';
  const tokenPayload = TokenPayload(
    sub: testCustomerId,
    role: UserRole.customer,
  );

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();
    orderRepo = _MockOrderRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(tokenPayload);
    when(() => context.read<OrderRepository>()).thenReturn(orderRepo);
  });

  group('GET /v1/customers/orders', () {
    test('returns 405 on POST method', () async {
      when(() => request.method).thenReturn(.post);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('returns 200 and forwards fromDate and toDate filters', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/customers/orders?fromDate=2026-09-14T18:30:00.000Z&toDate=2026-09-15T18:29:59.999Z&page=1&size=10',
        ),
      );

      when(
        () => orderRepo.getCustomerOrders(
          customerId: testCustomerId,
          fromDate: '2026-09-14T18:30:00.000Z',
          toDate: '2026-09-15T18:29:59.999Z',
        ),
      ).thenAnswer((_) async => (items: <Order>[], total: 0));

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      expect(body['data']['orders'], isEmpty);
      expect(body['data']['totalItems'], equals(0));
    });
  });
}
