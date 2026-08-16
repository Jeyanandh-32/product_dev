import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/v1/auth/customer/register.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}
class _MockRequest extends Mock implements Request {}
class _MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockCustomerRepository repo;

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();
    repo = _MockCustomerRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<CustomerRepository>()).thenReturn(repo);
  });

  group('POST /v1/auth/customer/register', () {
    test('returns 201 and customer session on valid registration', () async {
      when(() => request.method).thenReturn(.post);

      final customerRow = createCustomerRow(
        name: 'Jane Doe',
      );

      when(() => request.json()).thenAnswer(
        (_) async => {
          'name': 'Jane Doe',
          'mobileNumber': '9876543210',
          'pin': '123456',
        },
      );

      when(
        () => repo.create(
          name: 'Jane Doe',
          mobileNumber: '9876543210',
          pinHash: any(named: 'pinHash'),
        ),
      ).thenAnswer((_) async => customerRow);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final customer = data['customer'] as Map<String, dynamic>;
      expect(customer['name'], equals('Jane Doe'));
    });
  });
}
