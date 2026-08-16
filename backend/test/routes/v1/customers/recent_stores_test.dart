import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/customers/recent-stores.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockCustomerRepository repo;

  const testCustomerId = 'cust-1';
  const tokenPayload = TokenPayload(
    sub: testCustomerId,
    role: UserRole.customer,
  );

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();
    repo = _MockCustomerRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(tokenPayload);
    when(() => context.read<CustomerRepository>()).thenReturn(repo);
  });

  group('GET /v1/customers/recent-stores', () {
    test('responds with 200 and list of recent stores', () async {
      when(() => request.method).thenReturn(.get);

      final store1 = createStoreRow(
        id: '11111111-1111-1111-1111-111111111111',
        name: 'Store One',
      );
      final store2 = createStoreRow(
        id: '22222222-2222-2222-2222-222222222222',
        name: 'Store Two',
        merchantId: 'm-2',
      );

      when(
        () => repo.getRecentStores(customerId: testCustomerId),
      ).thenAnswer((_) async => [store1, store2]);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));

      final rawBody = await response.body();
      final body = jsonDecode(rawBody) as Map<String, dynamic>;
      expect(body['status'], equals('success'));

      final data = body['data'] as Map<String, dynamic>;
      final stores = data['stores'] as List<dynamic>;
      expect(stores.length, equals(2));
      final firstStore = stores[0] as Map<String, dynamic>;
      final secondStore = stores[1] as Map<String, dynamic>;
      expect(firstStore['name'], equals('Store One'));
      expect(secondStore['name'], equals('Store Two'));

      verify(() => repo.getRecentStores(customerId: testCustomerId)).called(1);
    });

    test('responds with 200 and empty list when no recent stores', () async {
      when(() => request.method).thenReturn(.get);
      when(
        () => repo.getRecentStores(customerId: testCustomerId),
      ).thenAnswer((_) async => []);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));

      final rawBody = await response.body();
      final body = jsonDecode(rawBody) as Map<String, dynamic>;
      expect(body['status'], equals('success'));

      final data = body['data'] as Map<String, dynamic>;
      final stores = data['stores'] as List<dynamic>;
      expect(stores, isEmpty);
    });

    test('responds with 500 when repository throws error', () async {
      when(() => request.method).thenReturn(.get);
      when(
        () => repo.getRecentStores(customerId: testCustomerId),
      ).thenThrow(Exception('Database connection failed'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.internalServerError));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
    });
  });

  group('POST /v1/customers/recent-stores', () {
    const validStoreId = '11111111-1111-1111-1111-111111111111';

    test('responds with 200 when store visit is recorded successfully', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer((_) async => {'storeId': validStoreId});
      when(
        () => repo.recordStoreVisit(
          customerId: testCustomerId,
          storeId: validStoreId,
        ),
      ).thenAnswer((_) async {});

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));

      final rawBody = await response.body();
      final body = jsonDecode(rawBody) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      expect(data['recorded'], isTrue);

      verify(
        () => repo.recordStoreVisit(
          customerId: testCustomerId,
          storeId: validStoreId,
        ),
      ).called(1);
    });

    test('responds with 400 when request body is invalid JSON', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenThrow(const FormatException('Invalid JSON'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with 400 when storeId is missing', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer((_) async => <String, dynamic>{});

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid store id.'));
    });

    test('responds with 400 when storeId is not a valid UUID', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer((_) async => {'storeId': 'invalid-uuid-123'});

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid store id.'));
    });

    test('responds with 500 when repository throws on recordStoreVisit', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer((_) async => {'storeId': validStoreId});
      when(
        () => repo.recordStoreVisit(
          customerId: testCustomerId,
          storeId: validStoreId,
        ),
      ).thenThrow(Exception('Failed to write visit record'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.internalServerError));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
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
