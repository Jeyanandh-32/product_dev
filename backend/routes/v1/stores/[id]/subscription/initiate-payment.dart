import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:validators/validators.dart';

/// Initiates a PhonePe checkout payment session for a store subscription.
Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    .post => _onPost(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context, String storeId) async {
  try {
    final body = await context.validateBody(
      StoreValidator.initiateSubscription,
    );
    final planCodeStr = (body['plan_code'] ?? body['planCode']) as String?;

    final planCode = SubscriptionPlanCode.values
        .where((c) => c.name == planCodeStr)
        .firstOrNull;
    if (planCode == null || planCode == SubscriptionPlanCode.trial) {
      return badRequest(message: 'Invalid plan code "$planCodeStr"');
    }

    final storeRepo = context.storeRepo;
    final store = await storeRepo.getById(storeId);
    if (store == null) {
      return notFound(message: 'Store not found');
    }

    final subRepo = context.subscriptionRepo;
    final plan = await subRepo.getPlanByCode(planCode);
    if (plan == null) {
      return notFound(message: 'Plan not found');
    }

    final platformConfigRepo = context.platformPhonePeConfigRepo;
    final platformConfig = platformConfigRepo.getConfig();
    if (platformConfig == null || !platformConfig.isEnabled) {
      return badRequest(message: 'Platform PhonePe gateway is not configured');
    }

    final merchantTransactionId =
        'SUB_${storeId}_${DateTime.now().millisecondsSinceEpoch}';
    final phonePeService = PhonePeService();
    final storePhonePeConfig = platformConfig.toStorePhonePeConfig(
      storeId: storeId,
    );

    final paymentSession = await phonePeService.initiatePayment(
      config: storePhonePeConfig,
      merchantOrderId: merchantTransactionId,
      amountInPaisa: plan.priceInPaise,
      redirectUrl: '/account',
      storeId: storeId,
    );

    await subRepo.recordPendingTransaction(
      storeId: storeId,
      planCode: planCode,
      amountInPaise: plan.priceInPaise,
      currency: plan.currency,
      reference: merchantTransactionId,
    );

    return success(
      data: {
        'storeId': storeId,
        'planCode': planCode.name,
        'merchantTransactionId': merchantTransactionId,
        'amountInPaise': plan.priceInPaise,
        'tokenUrl': paymentSession.tokenUrl,
        'redirectUrl': paymentSession.tokenUrl,
        'orderId': paymentSession.orderId,
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    final msg = e.toString().startsWith('Exception: ')
        ? e.toString().substring(11)
        : e.toString();
    return error(message: msg);
  }
}
