import 'dart:convert';
import 'dart:io';

import 'package:backend/repositories/store_repository.dart';
import 'package:backend/repositories/subscription_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/stores/[id]/subscription/index.dart' as get_route;
import '../../../../routes/v1/stores/[id]/subscription/renew.dart'
    as renew_route;
import '../../../helpers/schema_factories.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockStoreRepository extends Mock implements StoreRepository {}

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockStoreRepository storeRepo;
  late _MockSubscriptionRepository subRepo;

  const storeId = '11111111-1111-1111-1111-111111111111';

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    storeRepo = _MockStoreRepository();
    subRepo = _MockSubscriptionRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<StoreRepository>()).thenReturn(storeRepo);
    when(() => context.read<SubscriptionRepository>()).thenReturn(subRepo);
  });

  group('/v1/stores/:id/subscription', () {
    test('GET returns store subscription and active plan', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => storeRepo.getById(storeId)).thenAnswer(
        (_) async => createStoreRow(id: storeId, name: 'Main Branch'),
      );

      final subRow = createStoreSubscriptionRow(storeId: storeId);
      final planRow = createSubscriptionPlanRow();

      when(() => subRepo.getStoreSubscription(storeId))
          .thenAnswer((_) async => subRow);
      when(() => subRepo.getPlanByCode(SubscriptionPlanCode.trial))
          .thenAnswer((_) async => planRow);
      when(() => subRepo.getTransactions(storeId)).thenAnswer((_) async => []);

      final response = await get_route.onRequest(context, storeId);
      expect(response.statusCode, HttpStatus.ok);

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], 'success');
      final data = body['data'] as Map<String, dynamic>;
      expect((data['subscription'] as Map)['status'], 'trial');
      expect((data['plan'] as Map)['name'], '14-Day Free Trial');
    });

    test('GET returns 404 if store not found', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => storeRepo.getById(storeId)).thenAnswer((_) async => null);

      final response = await get_route.onRequest(context, storeId);
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('POST renews subscription successfully', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => storeRepo.getById(storeId)).thenAnswer(
        (_) async => createStoreRow(id: storeId, name: 'Main Branch'),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'plan_code': 'monthly',
          'payment_method': 'simulated',
        },
      );

      final renewedSub = createStoreSubscriptionRow(
        storeId: storeId,
        planCode: 'monthly',
      );
      final planRow = createSubscriptionPlanRow(
        code: 'monthly',
        name: 'Pro Monthly',
      );

      when(
        () => subRepo.renewSubscription(
          storeId: storeId,
          planCode: SubscriptionPlanCode.monthly,
        ),
      ).thenAnswer((_) async => renewedSub);
      when(() => subRepo.getPlanByCode(SubscriptionPlanCode.monthly))
          .thenAnswer((_) async => planRow);

      final response = await renew_route.onRequest(context, storeId);
      expect(response.statusCode, HttpStatus.ok);

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], 'success');
      final data = body['data'] as Map<String, dynamic>;
      expect((data['subscription'] as Map)['planCode'], 'monthly');
    });

    test(
      'POST renews subscription with camelCase planCode successfully',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => storeRepo.getById(storeId)).thenAnswer(
          (_) async => createStoreRow(id: storeId, name: 'Main Branch'),
        );
        when(() => request.json()).thenAnswer(
          (_) async => {
            'planCode': 'yearly',
            'paymentMethod': 'simulated',
          },
        );

        final renewedSub = createStoreSubscriptionRow(
          storeId: storeId,
          planCode: 'yearly',
        );
        final planRow = createSubscriptionPlanRow(
          code: 'yearly',
          name: 'Pro Yearly',
        );

        when(
          () => subRepo.renewSubscription(
            storeId: storeId,
            planCode: SubscriptionPlanCode.yearly,
          ),
        ).thenAnswer((_) async => renewedSub);
        when(() => subRepo.getPlanByCode(SubscriptionPlanCode.yearly))
            .thenAnswer((_) async => planRow);

        final response = await renew_route.onRequest(context, storeId);
        expect(response.statusCode, HttpStatus.ok);

        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['status'], 'success');
      },
    );

    test('POST returns 400 when plan_code is trial', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => storeRepo.getById(storeId)).thenAnswer(
        (_) async => createStoreRow(id: storeId, name: 'Main Branch'),
      );
      when(() => request.json()).thenAnswer(
        (_) async => {
          'plan_code': 'trial',
        },
      );

      final response = await renew_route.onRequest(context, storeId);
      expect(response.statusCode, HttpStatus.badRequest);
    });

    test('POST returns 400 when plan_code is missing', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => storeRepo.getById(storeId)).thenAnswer(
        (_) async => createStoreRow(id: storeId, name: 'Main Branch'),
      );
      when(() => request.json()).thenAnswer((_) async => {});

      final response = await renew_route.onRequest(context, storeId);
      expect(response.statusCode, HttpStatus.badRequest);
    });
  });
}
