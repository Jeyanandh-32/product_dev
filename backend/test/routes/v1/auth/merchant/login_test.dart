import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/services/auth_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/v1/auth/merchant/login.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}
class _MockRequest extends Mock implements Request {}
class _MockMerchantRepository extends Mock implements MerchantRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockMerchantRepository repo;

  setUp(() {
    Env.init();
    context = _MockRequestContext();
    request = _MockRequest();
    repo = _MockMerchantRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<MerchantRepository>()).thenReturn(repo);
  });

  group('POST /v1/auth/merchant/login', () {
    test('returns 200 and auth cookies on valid credentials', () async {
      when(() => request.method).thenReturn(.post);
      final hash = await PasswordService.hash('Password123');

      final merchantRow = createMerchantRow(
        passwordHash: hash,
      );

      when(() => request.json()).thenAnswer(
        (_) async => {'email': 'jack@test.com', 'password': 'Password123'},
      );
      when(() => repo.getByEmail('jack@test.com')).thenAnswer((_) async => merchantRow);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final merchant = data['merchant'] as Map<String, dynamic>;
      expect(merchant['email'], equals('jack@test.com'));
      expect(response.headers[HttpHeaders.setCookieHeader], isNotNull);
    });

    test('returns 400 when email is not found', () async {
      when(() => request.method).thenReturn(.post);
      when(() => request.json()).thenAnswer(
        (_) async => {'email': 'unknown@test.com', 'password': 'password123'},
      );
      when(() => repo.getByEmail('unknown@test.com')).thenAnswer((_) async => null);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('returns 400 when password does not match', () async {
      when(() => request.method).thenReturn(.post);
      final hash = await PasswordService.hash('correct_password');

      final merchantRow = createMerchantRow(
        passwordHash: hash,
      );

      when(() => request.json()).thenAnswer(
        (_) async => {'email': 'jack@test.com', 'password': 'wrong_password'},
      );
      when(() => repo.getByEmail('jack@test.com')).thenAnswer((_) async => merchantRow);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });
}
