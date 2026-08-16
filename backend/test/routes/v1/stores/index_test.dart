import 'dart:convert';
import 'dart:io';

import 'package:backend/database/schema.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/stores/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}
class _MockRequest extends Mock implements Request {}
class _MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockStoreRepository storeRepo;

  const token = TokenPayload(sub: 'm-1', role: UserRole.merchant);

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    storeRepo = _MockStoreRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(token);
    when(() => context.read<StoreRepository>()).thenReturn(storeRepo);
  });

  group('/v1/stores', () {
    test('GET responds with stores list and pagination', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/stores'),
      );

      final storeRows = [
        createStoreRow(
          id: '11111111-1111-1111-1111-111111111111',
          storeType: 'restaurant',
        ),
      ];

      when(() => storeRepo.count(merchantId: 'm-1')).thenAnswer((_) async => 1);
      when(
        () => storeRepo.getAll(
          merchantId: 'm-1',
          limit: 50,
          offset: 0,
        ),
      ).thenAnswer((_) async => storeRows);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      expect(data['currentPage'], equals(1));
      expect(data['totalItems'], equals(1));
      final stores = data['stores'] as List<dynamic>;
      expect(stores.length, equals(1));
      final firstStore = stores.first as Map<String, dynamic>;
      expect(firstStore['name'], equals('Downtown Store'));
    });

    test('GET responds with 400 when page parameter is invalid', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/stores?page=0'),
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
        Uri.parse('http://localhost/v1/stores?size=-10'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      final message = body['message'] as String;
      expect(message, contains('size must be a positive integer'));
    });

    test('POST creates store successfully', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/stores'),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'name': 'Uptown Store',
          'storeType': 'grocery',
          'slug': 'uptown-store',
        },
      );

      final createdStore = createStoreRow(
        id: '22222222-2222-2222-2222-222222222222',
        name: 'Uptown Store',
        storeType: 'grocery',
        slug: 'uptown-store',
      );

      when(
        () => storeRepo.create(
          merchantId: 'm-1',
          name: 'Uptown Store',
          storeType: StoreType.grocery,
          slug: 'uptown-store',
        ),
      ).thenAnswer((_) async => createdStore);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final store = data['store'] as Map<String, dynamic>;
      expect(store['name'], equals('Uptown Store'));
      expect(store['slug'], equals('uptown-store'));
    });

    test('POST responds with 400 when isOnlineEnabled is true', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/stores'),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'name': 'Online Store',
          'isOnlineEnabled': true,
          'slug': 'online-store',
        },
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      expect(
        body['message'],
        equals(
          'Cannot create a store with online ordering enabled. Please contact system administrator.',
        ),
      );
    });

    test('POST responds with 400 when body validation fails', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/stores'),
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
