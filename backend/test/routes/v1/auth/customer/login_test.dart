import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/v1/auth/customer/login.dart' as route;
import '../../../../helpers/schema_factories.dart';

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

  group('POST /v1/auth/customer/login', () {
    test('returns 200 and customer session on valid PIN', () async {
      when(() => request.method).thenReturn(.post);
      final pinHash = await PasswordService.hash('123456');

      final customerRow = createCustomerRow(
        pinHash: pinHash,
      );

      when(() => request.json()).thenAnswer(
        (_) async => {'mobileNumber': '9876543210', 'pin': '123456'},
      );
      when(() => repo.getByMobileNumber('9876543210')).thenAnswer((_) async => customerRow);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final customer = data['customer'] as Map<String, dynamic>;
      expect(customer['mobileNumber'], equals('9876543210'));
    });

    test('returns 400 when mobile number not found', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer(
        (_) async => {'mobileNumber': '9999999999', 'pin': '123456'},
      );
      when(() => repo.getByMobileNumber('9999999999')).thenAnswer((_) async => null);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });
}
