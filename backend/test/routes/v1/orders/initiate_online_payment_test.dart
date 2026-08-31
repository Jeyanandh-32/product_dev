import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/repositories/subscription_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/orders/initiate-online-payment.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockOrderService extends Mock implements OrderService {}

class _MockCustomerRepository extends Mock implements CustomerRepository {}

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockOrderService orderService;
  late _MockCustomerRepository customerRepo;
  late _MockSubscriptionRepository subscriptionRepo;

  const testCustomerId = 'cust-1';
  const testStoreId = '11111111-1111-1111-1111-111111111111';
  const testProductId = '22222222-2222-2222-2222-222222222222';
  const tokenPayload = TokenPayload(
    sub: testCustomerId,
    role: UserRole.customer,
  );

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();
    orderService = _MockOrderService();
    customerRepo = _MockCustomerRepository();
    subscriptionRepo = _MockSubscriptionRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(tokenPayload);
    when(() => context.read<OrderService>()).thenReturn(orderService);
    when(() => context.read<CustomerRepository>()).thenReturn(customerRepo);
    when(
      () => context.read<SubscriptionRepository>(),
    ).thenReturn(subscriptionRepo);
    when(
      () => subscriptionRepo.isStoreOperational(any()),
    ).thenAnswer((_) async => true);
  });

  group('POST /v1/orders/initiate-online-payment validation', () {
    test(
      'responds with 400 when store subscription is expired',
      () async {
        when(
          () => subscriptionRepo.isStoreOperational(testStoreId),
        ).thenAnswer((_) async => false);
        when(() => request.method).thenReturn(.post);
        when(
          () => request.uri,
        ).thenReturn(
          Uri.parse(
            'http://localhost/v1/orders/initiate-online-payment?storeId=$testStoreId',
          ),
        );
        when(() => request.json()).thenAnswer(
          (_) async => {
            'source': 'web',
            'type': 'takeaway',
            'paymentMethod': 'upi',
            'products': [
              {'productId': testProductId, 'quantity': 1},
            ],
          },
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(
          body['message'],
          equals(
            'Online ordering is currently unavailable because the store subscription has expired.',
          ),
        );
      },
    );

    test('responds with 400 when storeId query parameter is missing', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/orders/initiate-online-payment'),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Store ID is required.'));
    });

    test('responds with 400 when storeId is not a valid UUID', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/orders/initiate-online-payment?storeId=non-uuid-string',
        ),
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid store id.'));
    });

    test('responds with 400 when request body is invalid JSON', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/orders/initiate-online-payment?storeId=$testStoreId',
        ),
      );
      when(() => request.json())
          .thenThrow(const FormatException('Bad JSON format'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with 400 when products list is missing', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/orders/initiate-online-payment?storeId=$testStoreId',
        ),
      );
      when(() => request.json()).thenAnswer((_) async => {'useWallet': true});

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], contains('Products list is required.'));
    });

    test('responds with 400 when products list is empty', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/orders/initiate-online-payment?storeId=$testStoreId',
        ),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'products': <Map<String, dynamic>>[],
          'useWallet': true,
        },
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(
        body['message'],
        contains('Products list must contain at least one item.'),
      );
    });

    test('responds with 400 when product in list has non-positive quantity', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.uri).thenReturn(
        Uri.parse(
          'http://localhost/v1/orders/initiate-online-payment?storeId=$testStoreId',
        ),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'products': [
            {'productId': testProductId, 'quantity': 0},
          ],
        },
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });

  group('unsupported methods', () {
    test('responds with 405 for GET', () async {
      when(() => request.method).thenReturn(.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with 405 for DELETE', () async {
      when(() => request.method).thenReturn(.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('responds with 405 for PUT', () async {
      when(() => request.method).thenReturn(.put);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
