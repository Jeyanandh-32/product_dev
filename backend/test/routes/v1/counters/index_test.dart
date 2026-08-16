import 'dart:convert';
import 'dart:io';

import 'package:backend/database/schema.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/counter_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/counters/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}
class _MockRequest extends Mock implements Request {}
class _MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockCounterRepository counterRepo;

  const validStoreId = '11111111-1111-1111-1111-111111111111';
  const token = TokenPayload(sub: 'm-1', role: UserRole.merchant);

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    counterRepo = _MockCounterRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(token);
    when(() => context.read<CounterRepository>()).thenReturn(counterRepo);
  });

  group('/v1/counters', () {
    test('GET responds with counters and pagination', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=$validStoreId'),
      );

      final counterRows = [
        createCounterRow(
          name: 'Front Counter',
          storeId: validStoreId,
        ),
      ];

      when(
        () => counterRepo.count(
          merchantId: 'm-1',
          storeId: validStoreId,
          searchQuery: any(named: 'searchQuery'),
        ),
      ).thenAnswer((_) async => 1);

      when(
        () => counterRepo.getAll(
          merchantId: 'm-1',
          storeId: validStoreId,
          searchQuery: any(named: 'searchQuery'),
          limit: 50,
          offset: 0,
        ),
      ).thenAnswer((_) async => counterRows);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      expect(data['currentPage'], equals(1));
      expect(data['totalItems'], equals(1));
      final counters = data['counters'] as List<dynamic>;
      expect(counters.length, equals(1));
      final firstCounter = counters.first as Map<String, dynamic>;
      expect(firstCounter['name'], equals('Front Counter'));
    });

    test('GET responds with filtered counters on search query', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=$validStoreId&search=front'),
      );

      final counterRows = [
        createCounterRow(
          name: 'Front Counter',
          storeId: validStoreId,
        ),
      ];

      when(
        () => counterRepo.count(
          merchantId: 'm-1',
          storeId: validStoreId,
          searchQuery: 'front',
        ),
      ).thenAnswer((_) async => 1);

      when(
        () => counterRepo.getAll(
          merchantId: 'm-1',
          storeId: validStoreId,
          searchQuery: 'front',
          limit: 50,
          offset: 0,
        ),
      ).thenAnswer((_) async => counterRows);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final counters = data['counters'] as List<dynamic>;
      expect(counters.length, equals(1));
    });

    test('GET responds with 400 when storeId is invalid UUID', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=not-a-valid-uuid'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      expect(body['message'], equals('Invalid store id.'));
    });

    test('GET responds with 400 when page parameter is invalid', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=$validStoreId&page=0'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      final message = body['message'] as String;
      expect(message, contains('page must be a positive integer'));
    });

    test('GET responds with 400 when size parameter is invalid', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=$validStoreId&size=0'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      final message = body['message'] as String;
      expect(message, contains('size must be a positive integer'));
    });

    test('POST creates counter successfully', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=$validStoreId'),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'name': 'Express Counter',
          'description': 'Quick checkout counter',
        },
      );

      final createdCounter = createCounterRow(
        id: 'counter-2',
        name: 'Express Counter',
        description: 'Quick checkout counter',
        storeId: validStoreId,
      );

      when(
        () => counterRepo.create(
          merchantId: 'm-1',
          storeId: validStoreId,
          name: 'Express Counter',
          description: 'Quick checkout counter',
        ),
      ).thenAnswer((_) async => createdCounter);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final counter = data['counter'] as Map<String, dynamic>;
      expect(counter['name'], equals('Express Counter'));
    });

    test('POST responds with 400 when storeId is missing', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      expect(body['message'], equals('Store ID is required.'));
    });

    test('POST responds with 400 when storeId is invalid UUID', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=not-a-uuid'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      expect(body['message'], equals('Invalid store id.'));
    });

    test('POST responds with 400 when body validation fails', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/counters?storeId=$validStoreId'),
      );
      when(() => request.json()).thenAnswer((_) async => <String, dynamic>{});

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      expect(body['message'], equals('Name is required.'));
    });

    test('DELETE responds with 405 Method Not Allowed', () async {
      when(() => request.method).thenReturn(.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
