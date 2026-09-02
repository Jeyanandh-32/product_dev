import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/subscription_row_extension.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;
import 'package:validators/validators.dart';

/// Verifies PhonePe payment status and activates/renews the store subscription.
Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    .post => _onPost(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context, String storeId) async {
  try {
    final body = await context.validateBody(StoreValidator.verifySubscription);
    final input = StoreSubscriptionVerify.fromJson(body);
    final merchantTxId = input.merchantTransactionId;

    final db = context.db;
    final subRepo = context.subscriptionRepo;
    final txList = await db.subscriptionTransactions
        .where((t) => t.reference.equals(toExpr(merchantTxId)))
        .fetch();
    final tx = txList.firstOrNull;

    if (tx == null) {
      return notFound(message: 'Subscription transaction not found');
    }

    final planCode =
        SubscriptionPlanCode.values
            .where((p) => p.name == tx.planCode)
            .firstOrNull ??
        SubscriptionPlanCode.monthly;

    if (tx.status == 'completed' || tx.status == 'success') {
      final subRow = await subRepo.getStoreSubscription(storeId);
      final planRow = await subRepo.getPlanByCode(planCode);
      return success(
        data: {
          'subscription': subRow?.toStoreSubscription().toJson(),
          'plan': planRow?.toSubscriptionPlan().toJson(),
        },
      );
    }

    final platformConfigRepo = context.platformPhonePeConfigRepo;
    final platformConfig = platformConfigRepo.getConfig();
    if (platformConfig != null && platformConfig.isEnabled) {
      final phonePeService = PhonePeService();
      final statusResult = await phonePeService.checkOrderStatus(
        config: platformConfig.toStorePhonePeConfig(storeId: storeId),
        merchantOrderId: merchantTxId,
      );

      final state =
          (statusResult['state'] as String?) ??
          (statusResult['data'] is Map
              ? (statusResult['data'] as Map)['state'] as String?
              : null);

      final stateUpper = state?.toUpperCase();
      if (stateUpper == 'COMPLETED' || stateUpper == 'SUCCESS') {
        final renewedSub = await subRepo.renewSubscription(
          storeId: storeId,
          planCode: planCode,
          paymentMethod: SubscriptionPaymentMethod.phonepe,
          reference: merchantTxId,
        );
        final planRow = await subRepo.getPlanByCode(planCode);

        return success(
          data: {
            'subscription': renewedSub.toStoreSubscription().toJson(),
            'plan': planRow?.toSubscriptionPlan().toJson(),
          },
        );
      } else if (stateUpper == 'FAILED' || stateUpper == 'CANCELLED') {
        await db.subscriptionTransactions
            .byKey(tx.id)
            .update((t, set) => set(status: toExpr('failed')))
            .execute();
        return badRequest(message: 'Payment was unsuccessful ($stateUpper)');
      }
    }

    return badRequest(message: 'Payment verification is still pending');
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
