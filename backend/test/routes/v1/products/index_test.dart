import 'dart:convert';
import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/services/product_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/products/index.dart' as route;
import '../../../helpers/schema_factories.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockProductRepository extends Mock implements ProductRepository {}

class _MockProductService extends Mock implements ProductService {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockProductRepository productRepo;
  late _MockProductService productService;

  const validStoreId = '11111111-1111-1111-1111-111111111111';
  const merchantToken = TokenPayload(sub: 'm-1', role: UserRole.merchant);

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    productRepo = _MockProductRepository();
    productService = _MockProductService();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(merchantToken);
    when(() => context.read<ProductRepository>()).thenReturn(productRepo);
    when(() => context.read<ProductService>()).thenReturn(productService);
  });

  group('/v1/products', () {
    test('GET responds with products and pagination for merchant', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/products?storeId=$validStoreId'),
      );

      final productRow = createProductRow(
        name: 'Hot Chocolate',
        storeId: validStoreId,
      );
      final stockRow = createStockRow(
        id: 's-1',
        storeId: validStoreId,
      );
      final catRow = createCategoryRow(
        id: 'cat-2',
        storeId: validStoreId,
      );
      final counterRow = createCounterRow(
        id: 'cnt-1',
        storeId: validStoreId,
      );

      when(
        () => productRepo.count(
          storeId: validStoreId,
          merchantId: 'm-1',
          searchQuery: any(named: 'searchQuery'),
          isActive: any(named: 'isActive'),
        ),
      ).thenAnswer((_) async => 1);

      when(
        () => productRepo.getAll(
          storeId: validStoreId,
          merchantId: 'm-1',
          searchQuery: any(named: 'searchQuery'),
          isActive: any(named: 'isActive'),
          limit: 50,
          offset: 0,
        ),
      ).thenAnswer((_) async => [(productRow, stockRow, catRow, counterRow)]);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      expect(data['currentPage'], equals(1));
      expect(data['totalItems'], equals(1));
      final products = data['products'] as List<dynamic>;
      expect(products.length, equals(1));
      final firstProduct = products.first as Map<String, dynamic>;
      expect(firstProduct['name'], equals('Hot Chocolate'));
    });

    test('GET responds with products for customer role with null merchantId filter', () async {
      const customerToken = TokenPayload(
        sub: 'cust-1',
        role: UserRole.customer,
      );
      when(() => context.read<TokenPayload>()).thenReturn(customerToken);

      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/products?storeId=$validStoreId'),
      );

      final productRow = createProductRow(
        name: 'Hot Chocolate',
        storeId: validStoreId,
      );

      when(
        () => productRepo.count(
          storeId: validStoreId,
          searchQuery: any(named: 'searchQuery'),
          isActive: any(named: 'isActive'),
        ),
      ).thenAnswer((_) async => 1);

      when(
        () => productRepo.getAll(
          storeId: validStoreId,
          searchQuery: any(named: 'searchQuery'),
          isActive: any(named: 'isActive'),
          limit: 50,
          offset: 0,
        ),
      ).thenAnswer((_) async => [(productRow, null, null, null)]);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final products = data['products'] as List<dynamic>;
      expect(products.length, equals(1));
    });

    test('GET responds with filtered products on search query', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/products?storeId=$validStoreId&search=chocolate',
        ),
      );

      final productRow = createProductRow(
        name: 'Hot Chocolate',
        storeId: validStoreId,
      );

      when(
        () => productRepo.count(
          storeId: validStoreId,
          merchantId: 'm-1',
          searchQuery: 'chocolate',
          isActive: any(named: 'isActive'),
        ),
      ).thenAnswer((_) async => 1);

      when(
        () => productRepo.getAll(
          storeId: validStoreId,
          merchantId: 'm-1',
          searchQuery: 'chocolate',
          isActive: any(named: 'isActive'),
          limit: 50,
          offset: 0,
        ),
      ).thenAnswer((_) async => [(productRow, null, null, null)]);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final products = data['products'] as List<dynamic>;
      expect(products.length, equals(1));
    });

    test('GET forwards isActive query parameter when specified', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/products?storeId=$validStoreId&isActive=true',
        ),
      );

      when(
        () => productRepo.count(
          storeId: validStoreId,
          merchantId: 'm-1',
          searchQuery: any(named: 'searchQuery'),
          isActive: true,
        ),
      ).thenAnswer((_) async => 1);

      when(
        () => productRepo.getAll(
          storeId: validStoreId,
          merchantId: 'm-1',
          searchQuery: any(named: 'searchQuery'),
          isActive: true,
          limit: 50,
          offset: 0,
        ),
      ).thenAnswer(
        (_) async => [
          (createProductRow(storeId: validStoreId), null, null, null),
        ],
      );

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('GET responds with 400 when storeId is missing', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/products'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      expect(body['message'], equals('Store ID is required.'));
    });

    test('GET responds with 400 when storeId is invalid UUID', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/products?storeId=invalid-uuid'),
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
        Uri.parse('http://localhost/v1/products?storeId=$validStoreId&page=0'),
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
        Uri.parse('http://localhost/v1/products?storeId=$validStoreId&size=-5'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      final message = body['message'] as String;
      expect(message, contains('size must be a positive integer'));
    });

    test('POST creates product successfully via ProductService', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/products?storeId=$validStoreId'),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'name': 'Cold Coffee',
          'categoryId': 'cat-1',
          'counterId': 'cnt-1',
          'basePrice': 20,
          'sellingPrice': 50,
          'sku': 'SKU123',
          'barcode': 'BAR123',
          'description': 'Fresh brew',
          'imageUrl': 'https://example.com/coffee.jpg',
          'taxRate': 5.0,
        },
      );

      final createdProduct = Product(
        id: 'p-1',
        merchantId: 'm-1',
        name: 'Cold Coffee',
        basePrice: 20,
        sellingPrice: 50,
        taxRate: 5,
        sku: 'SKU123',
        barcode: 'BAR123',
        description: 'Fresh brew',
        imageUrl: 'https://example.com/coffee.jpg',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(
        () => productService.create(
          merchantId: 'm-1',
          storeId: validStoreId,
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => createdProduct);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final product = data['product'] as Map<String, dynamic>;
      expect(product['name'], equals('Cold Coffee'));
      expect(product['sellingPrice'], equals(50));
    });

    test('POST responds with 400 when storeId is missing', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/products'),
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
        Uri.parse('http://localhost/v1/products?storeId=bad-store-id'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
      expect(body['message'], equals('Invalid store id.'));
    });

    test(
      'POST responds with 400 when required body fields are missing',
      () async {
        when(() => request.method).thenReturn(.post);
        when(() => request.uri).thenReturn(
          Uri.parse('http://localhost/v1/products?storeId=$validStoreId'),
        );
        when(() => request.json()).thenAnswer((_) async => <String, dynamic>{});

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], equals('error'));
        expect(body['message'], equals('Name is required.'));
      },
    );

    test('DELETE responds with 405 Method Not Allowed', () async {
      when(() => request.method).thenReturn(.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
