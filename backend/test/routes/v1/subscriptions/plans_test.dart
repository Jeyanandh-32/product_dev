import 'dart:convert';
import 'dart:io';

import 'package:backend/repositories/subscription_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/v1/subscriptions/plans.dart' as route;
import '../../../helpers/schema_factories.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockSubscriptionRepository subRepo;

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    subRepo = _MockSubscriptionRepository();

    when(() => context.request).thenReturn(request);
    when(() => context.read<SubscriptionRepository>()).thenReturn(subRepo);
  });

  group('/v1/subscriptions/plans', () {
    test('GET returns list of available plans', () async {
      when(() => request.method).thenReturn(HttpMethod.get);

      final plans = [
        createSubscriptionPlanRow(),
        createSubscriptionPlanRow(
          code: 'pro_monthly',
          name: 'Pro Monthly',
          priceInPaise: 29900,
        ),
      ];

      when(() => subRepo.getPlans()).thenAnswer((_) async => plans);

      final response = await route.onRequest(context);
      expect(response.statusCode, HttpStatus.ok);

      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['status'], 'success');
      final returnedPlans =
          ((body['data'] as Map<String, dynamic>)['plans'] as List)
              .cast<Map<String, dynamic>>();
      expect(returnedPlans.length, 2);
      expect(returnedPlans.first['code'], 'trial');
    });

    test('Non-GET method returns 405', () async {
      when(() => request.method).thenReturn(HttpMethod.post);

      final response = await route.onRequest(context);
      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
