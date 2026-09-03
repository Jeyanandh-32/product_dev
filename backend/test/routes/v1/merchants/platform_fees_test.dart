import 'dart:convert';
import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/platform_fee_repository.dart';
import 'package:backend/repositories/platform_phonepe_config_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/merchants/platform-fees/index.dart' as index_route;
import '../../../../routes/v1/merchants/platform-fees/initiate-payment.dart'
    as initiate_route;
import '../../../../routes/v1/merchants/platform-fees/verify-payment.dart'
    as verify_route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockPlatformFeeRepository extends Mock
    implements PlatformFeeRepository {}

class _MockPlatformPhonePeConfigRepository extends Mock
    implements PlatformPhonePeConfigRepository {}

const _testMerchantId = 'merchant-123';
const _testTokenPayload = TokenPayload(
  sub: _testMerchantId,
  role: UserRole.merchant,
);

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockPlatformFeeRepository repo;
  late _MockPlatformPhonePeConfigRepository configRepo;

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    repo = _MockPlatformFeeRepository();
    configRepo = _MockPlatformPhonePeConfigRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(_testTokenPayload);
    when(() => context.read<PlatformFeeRepository>()).thenReturn(repo);
    when(
      () => context.read<PlatformPhonePeConfigRepository>(),
    ).thenReturn(configRepo);
    when(
      () => repo.getPendingSettlements(_testMerchantId),
    ).thenAnswer((_) async => []);
  });

  group('GET /v1/merchants/platform-fees', () {
    test('responds with 200 and platform fee summary', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => repo.getPlatformFeeSummary(_testMerchantId)).thenAnswer(
        (_) async => const MerchantPlatformFeeSummary(
          unsettledAmountInPaise: 4500,
          unsettledOrdersCount: 5,
        ),
      );

      final response = await index_route.onRequest(context);
      expect(response.statusCode, HttpStatus.ok);

      final json = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(json['status'], 'success');
      expect(json['data']['unsettledAmountInPaise'], 4500);
      expect(json['data']['unsettledOrdersCount'], 5);
    });

    test('responds with 405 for POST', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await index_route.onRequest(context);
      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });

  group('POST /v1/merchants/platform-fees/verify-payment', () {
    test('reconciles and responds with 200 and updated summary', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => repo.getPlatformFeeSummary(_testMerchantId)).thenAnswer(
        (_) async => const MerchantPlatformFeeSummary(
          unsettledAmountInPaise: 0,
          unsettledOrdersCount: 0,
        ),
      );

      final response = await verify_route.onRequest(context);
      expect(response.statusCode, HttpStatus.ok);

      final json = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(json['status'], 'success');
      expect(json['data']['unsettledAmountInPaise'], 0);
    });

    test('responds with 405 for GET', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await verify_route.onRequest(context);
      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });

  group('POST /v1/merchants/platform-fees/initiate-payment', () {
    test('responds with 400 when unsettled amount is zero', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => repo.getPlatformFeeSummary(_testMerchantId)).thenAnswer(
        (_) async => const MerchantPlatformFeeSummary(
          unsettledAmountInPaise: 0,
          unsettledOrdersCount: 0,
        ),
      );

      final response = await initiate_route.onRequest(context);
      expect(response.statusCode, HttpStatus.badRequest);
    });

    test('responds with 405 for GET', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await initiate_route.onRequest(context);
      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
