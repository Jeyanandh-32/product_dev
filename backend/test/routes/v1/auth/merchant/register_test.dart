import 'dart:convert';
import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/v1/auth/merchant/register.dart' as route;
import '../../../../helpers/schema_factories.dart';

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

  group('POST /v1/auth/merchant/register', () {
    test('returns 201 and creates merchant on valid payload', () async {
      when(() => request.method).thenReturn(.post);

      final merchantRow = createMerchantRow(
        
      );

      when(() => request.json()).thenAnswer(
        (_) async => {
          'name': 'Jack Owner',
          'businessName': 'SuperMart',
          'whatsappNumber': '9876543210',
          'email': 'jack@test.com',
          'password': 'Password123',
        },
      );

      when(
        () => repo.create(
          name: 'Jack Owner',
          businessName: 'SuperMart',
          whatsappNumber: '9876543210',
          email: 'jack@test.com',
          passwordHash: any(named: 'passwordHash'),
        ),
      ).thenAnswer((_) async => merchantRow);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], equals('success'));
      final data = body['data'] as Map<String, dynamic>;
      final merchant = data['merchant'] as Map<String, dynamic>;
      expect(merchant['name'], equals('Jack Owner'));
    });
  });
}
