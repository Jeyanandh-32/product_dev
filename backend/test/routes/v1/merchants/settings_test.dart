import 'dart:convert';
import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/merchant_settings_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/merchants/settings.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockMerchantSettingsRepository extends Mock
    implements MerchantSettingsRepository {}

const _testMerchantId = 'test-merchant-id';
const _testTokenPayload = TokenPayload(
  sub: _testMerchantId,
  role: UserRole.merchant,
);

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockMerchantSettingsRepository repo;

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    repo = _MockMerchantSettingsRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<TokenPayload>()).thenReturn(_testTokenPayload);
    when(() => context.read<MerchantSettingsRepository>()).thenReturn(repo);
  });

  group('GET /v1/merchants/settings', () {
    test('responds with 200 and default settings', () async {
      when(() => request.method).thenReturn(.get);

      final settings = MerchantSettings(
        merchantId: _testMerchantId,
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      );

      when(
        () => repo.getSettingsByMerchantId(_testMerchantId),
      ).thenAnswer((_) async => settings);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));

      final rawBody = await response.body();
      final body = jsonDecode(rawBody) as Map<String, dynamic>;
      expect(body['status'], equals('success'));

      final returnedSettings = body['data'] as Map<String, dynamic>;
      final settingsData = returnedSettings['settings'] as Map<String, dynamic>;

      expect(settingsData['merchantId'], equals(_testMerchantId));
      expect(settingsData['waNotifications'], isTrue);
      expect(settingsData['lowStockAlerts'], isTrue);
      expect(settingsData['dailyReports'], isFalse);

      verify(() => repo.getSettingsByMerchantId(_testMerchantId)).called(1);
    });
  });

  group('PATCH /v1/merchants/settings', () {
    test('responds with 200 and updated settings', () async {
      when(() => request.method).thenReturn(.patch);
      when(() => request.json()).thenAnswer(
        (_) async => {
          'waNotifications': false,
          'dailyReports': true,
        },
      );

      final updatedSettings = MerchantSettings(
        merchantId: _testMerchantId,
        waNotifications: false,
        dailyReports: true,
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      );

      when(
        () => repo.updateSettings(
          merchantId: _testMerchantId,
          waNotifications: false,
          lowStockAlerts: any(named: 'lowStockAlerts'),
          dailyReports: true,
        ),
      ).thenAnswer((_) async => updatedSettings);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));

      final rawBody = await response.body();
      final body = jsonDecode(rawBody) as Map<String, dynamic>;
      expect(body['status'], equals('success'));

      final returnedSettings = body['data'] as Map<String, dynamic>;
      final settingsData = returnedSettings['settings'] as Map<String, dynamic>;

      expect(settingsData['waNotifications'], isFalse);
      expect(settingsData['dailyReports'], isTrue);
    });
  });

  group('unsupported methods', () {
    test('responds with 405 for DELETE', () async {
      when(() => request.method).thenReturn(.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
