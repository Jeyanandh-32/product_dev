import 'dart:io';

import 'package:backend/repositories/platform_phonepe_config_repository.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/repositories/subscription_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/stores/[id]/subscription/initiate-payment.dart'
    as initiate_route;
import '../../../../routes/v1/stores/[id]/subscription/verify-payment.dart'
    as verify_route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockStoreRepository extends Mock implements StoreRepository {}

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class _MockPlatformPhonePeConfigRepository extends Mock
    implements PlatformPhonePeConfigRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockStoreRepository storeRepo;
  late _MockSubscriptionRepository subRepo;
  late _MockPlatformPhonePeConfigRepository platformConfigRepo;

  const storeId = '11111111-1111-1111-1111-111111111111';

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    storeRepo = _MockStoreRepository();
    subRepo = _MockSubscriptionRepository();
    platformConfigRepo = _MockPlatformPhonePeConfigRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<StoreRepository>()).thenReturn(storeRepo);
    when(() => context.read<SubscriptionRepository>()).thenReturn(subRepo);
    when(() => context.read<PlatformPhonePeConfigRepository>())
        .thenReturn(platformConfigRepo);
  });

  group('POST /v1/stores/:id/subscription/initiate-payment', () {
    test('rejects missing planCode with 400', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => <String, dynamic>{});

      final response = await initiate_route.onRequest(context, storeId);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('rejects trial plan renewal with 400', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => {'planCode': 'trial'});

      final response = await initiate_route.onRequest(context, storeId);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('returns 404 when store not found', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => {'planCode': 'yearly'});
      when(() => storeRepo.getById(storeId)).thenAnswer((_) async => null);

      final response = await initiate_route.onRequest(context, storeId);
      expect(response.statusCode, equals(HttpStatus.notFound));
    });
  });

  group('POST /v1/stores/:id/subscription/verify-payment', () {
    test('rejects missing merchantTransactionId with 400', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => <String, dynamic>{});

      final response = await verify_route.onRequest(context, storeId);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });
}
