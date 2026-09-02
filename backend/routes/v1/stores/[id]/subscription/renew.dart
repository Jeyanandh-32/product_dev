import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/subscription_row_extension.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:validators/validators.dart';

/// Handler for `POST /v1/stores/:id/subscription/renew`.
Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context, String storeId) async {
  final storeRepo = context.storeRepo;
  final store = await storeRepo.getById(storeId);
  if (store == null) {
    return notFound(message: 'Store not found.');
  }

  try {
    final body = await context.validateBody(StoreValidator.renewSubscription);
    final rawPlanCode = (body['plan_code'] ?? body['planCode']) as String?;
    final rawPaymentMethod =
        (body['payment_method'] ?? body['paymentMethod'] ?? 'simulated')
            as String;
    final reference = body['reference'] as String?;

    final planCode = SubscriptionPlanCode.tryParse(rawPlanCode);
    if (planCode == null || planCode == SubscriptionPlanCode.trial) {
      return badRequest(
        message: 'Invalid plan code or trial cannot be selected.',
      );
    }

    final subRepo = context.subscriptionRepo;
    final plan = await subRepo.getPlanByCode(planCode);
    if (plan == null) {
      return badRequest(message: 'Subscription plan not found.');
    }

    final renewedSubRow = await subRepo.renewSubscription(
      storeId: storeId,
      planCode: planCode,
      paymentMethod:
          SubscriptionPaymentMethod.tryParse(rawPaymentMethod) ??
          SubscriptionPaymentMethod.simulated,
      reference: reference,
    );

    return success(
      data: {
        'subscription': renewedSubRow.toStoreSubscription().toJson(),
        'plan': plan.toSubscriptionPlan().toJson(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  }
}
