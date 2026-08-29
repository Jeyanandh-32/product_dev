import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/customers/wallet.dart' as route;
import '../../../helpers/schema_factories.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockCustomerRepository repo;

  const testCustomerId = 'cust-1';
  const testStoreId = '11111111-1111-1111-1111-111111111111';
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

  group('GET /v1/customers/wallet', () {
    test('responds with 400 when storeId query parameter is missing', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/customers/wallet'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('storeId is required.'));
    });

    test('responds with 400 when storeId is empty', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(Uri.parse('http://localhost/v1/customers/wallet?storeId='));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('storeId is required.'));
    });

    test('responds with 400 when customer is not found in repository', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/customers/wallet?storeId=$testStoreId'),
      );
      when(() => repo.getById(testCustomerId)).thenAnswer((_) async => null);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Customer not found.'));
    });

    test('responds with 200 and wallet details when customer exists and has transactions', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/customers/wallet?storeId=$testStoreId'),
      );

      final customer = createCustomerRow();
      final transaction1 = createCustomerWalletTransactionRow(
        storeId: testStoreId,
        amount: 2500, // ₹25.00
      );
      final transaction2 = createCustomerWalletTransactionRow(
        id: 'tx-2',
        storeId: testStoreId,
        amount: 1000, // ₹10.00
        type: 'order_debit',
      );

      when(() => repo.getById(testCustomerId)).thenAnswer((_) async => customer);
      when(
        () => repo.getWalletTransactions(
          customerId: testCustomerId,
          storeId: testStoreId,
        ),
      ).thenAnswer((_) async => [transaction1, transaction2]);
      when(
        () => repo.getStoreWalletBalance(
          customerId: testCustomerId,
          storeId: testStoreId,
        ),
      ).thenAnswer((_) async => 1500); // ₹15.00

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));

      final data = body['data'] as Map<String, dynamic>;
      expect(data['balance'], equals(15.0));

      final transactions = data['transactions'] as List<dynamic>;
      expect(transactions.length, equals(2));
      final tx1 = transactions[0] as Map<String, dynamic>;
      final tx2 = transactions[1] as Map<String, dynamic>;
      expect(tx1['id'], equals('tx-1'));
      expect(tx1['amount'], equals(25.0));
      expect(tx2['id'], equals('tx-2'));
      expect(tx2['amount'], equals(10.0));
    });

    test('responds with 500 when repository getById throws exception', () async {
      when(() => request.method).thenReturn(.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/customers/wallet?storeId=$testStoreId'),
      );
      when(() => repo.getById(testCustomerId)).thenThrow(Exception('Database error'));

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.internalServerError));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('error'));
    });
  });

  group('POST /v1/customers/wallet validation', () {
    test('responds with 400 when amount is missing', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer(
        (_) async => {'storeId': testStoreId},
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid top up amount.'));
    });

    test('responds with 400 when amount is zero or negative', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer(
        (_) async => {'amount': 0, 'storeId': testStoreId},
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('Invalid top up amount.'));
    });

    test('responds with 400 when storeId is missing for wallet top-up', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer(
        (_) async => {'amount': 50.0},
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('storeId is required for wallet top-up.'));
    });

    test('responds with 400 when storeId is empty for wallet top-up', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer(
        (_) async => {'amount': 50.0, 'storeId': ''},
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['message'], equals('storeId is required for wallet top-up.'));
    });
  });

  group('unsupported methods', () {
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
