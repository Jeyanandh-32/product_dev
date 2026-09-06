import 'dart:convert';
import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/category_repository.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/categories/index.dart' as route;
import '../../../helpers/schema_factories.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCategoryRepository extends Mock implements CategoryRepository {}

class _MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockCategoryRepository catRepo;
  late _MockStoreRepository storeRepo;

  const token = TokenPayload(sub: 'm-1', role: UserRole.merchant);

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    catRepo = _MockCategoryRepository();
    storeRepo = _MockStoreRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(token);
    when(() => context.read<CategoryRepository>()).thenReturn(catRepo);
    when(() => context.read<StoreRepository>()).thenReturn(storeRepo);
  });

  group('/v1/categories', () {
    test('GET responds with categories and pagination', () async {
      const validStoreId = '11111111-1111-1111-1111-111111111111';
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/categories?storeId=$validStoreId'),
      );

      final storeRow = createStoreRow(id: validStoreId);
      final catRows = [createCategoryRow(storeId: validStoreId)];

      when(() => storeRepo.getById(validStoreId))
          .thenAnswer((_) async => storeRow);
      when(
        () => catRepo.getAll(
          merchantId: 'm-1',
          storeId: validStoreId,
          limit: 50,
          offset: 0,
          isActive: any(named: 'isActive'),
        ),
      ).thenAnswer((_) async => catRows);
      when(
        () => catRepo.count(
          merchantId: 'm-1',
          storeId: validStoreId,
          isActive: any(named: 'isActive'),
        ),
      ).thenAnswer((_) async => 1);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final categories = data['categories'] as List<dynamic>;
      expect(categories.length, equals(1));
    });

    test('POST creates category successfully', () async {
      const validStoreId = '11111111-1111-1111-1111-111111111111';
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/categories?storeId=$validStoreId'),
      );
      when(() => request.json()).thenAnswer((_) async => {'name': 'Desserts'});

      final storeRow = createStoreRow(id: validStoreId);
      final newCatRow = createCategoryRow(
        id: 'cat-2',
        name: 'Desserts',
        storeId: validStoreId,
      );

      when(() => storeRepo.getById(validStoreId))
          .thenAnswer((_) async => storeRow);
      when(
        () => catRepo.create(
          merchantId: 'm-1',
          storeId: validStoreId,
          name: 'Desserts',
        ),
      ).thenAnswer((_) async => newCatRow);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final category = data['category'] as Map<String, dynamic>;
      expect(category['name'], equals('Desserts'));
    });
  });
}
