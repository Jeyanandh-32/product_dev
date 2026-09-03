import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

/// Initiates a PhonePe payment session to settle accumulated platform fees.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  try {
    final tokenPayload = context.tokenPayload;
    final merchantId = tokenPayload.sub;
    final repo = context.platformFeeRepo;
    final summary = await repo.getPlatformFeeSummary(merchantId);

    if (summary.unsettledAmountInPaise <= 0) {
      return badRequest(message: 'No unsettled platform fees to pay.');
    }

    final platformConfig = context.platformPhonePeConfigRepo.getConfig();
    if (platformConfig == null || !platformConfig.isEnabled) {
      return badRequest(message: 'Platform PhonePe gateway is not configured.');
    }

    final settlement = await repo.createSettlement(
      merchantId: merchantId,
      amountInPaise: summary.unsettledAmountInPaise,
      ordersCount: summary.unsettledOrdersCount,
      paymentGateway: 'phonepe',
    );

    final merchantOrderId = 'PFS_${settlement.id}';
    final phonePeConfig = platformConfig.toStorePhonePeConfig(
      storeId: settlement.id,
    );
    final phonePeService = PhonePeService();

    final paymentSession = await phonePeService.initiatePayment(
      config: phonePeConfig,
      merchantOrderId: merchantOrderId,
      amountInPaisa: summary.unsettledAmountInPaise,
      redirectUrl: '/account',
    );

    return success(
      data: {
        'tokenUrl': paymentSession.tokenUrl,
        'settlementId': settlement.id,
        'merchantOrderId': merchantOrderId,
        'phonePeOrderId': paymentSession.orderId,
        'amountInPaise': summary.unsettledAmountInPaise,
      },
    );
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
