import 'dart:convert';

import 'package:backend/repositories/platform_fee_repository.dart';
import 'package:backend/repositories/platform_phonepe_config_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

/// Public webhook receiver for PhonePe platform fee settlement notifications.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  try {
    final rawBody = await context.request.body();
    final json = jsonDecode(rawBody) as Map<String, dynamic>;
    final event = json['event'] as String?;
    final payload = json['payload'] as Map<String, dynamic>?;

    if (event == null || payload == null) {
      return badRequest(message: 'Invalid webhook payload structure');
    }

    final merchantOrderId = payload['merchantOrderId'] as String?;
    final state = payload['state'] as String?;
    final transactionId =
        payload['transactionId'] as String? ?? merchantOrderId ?? '';

    if (merchantOrderId == null || state == null) {
      return badRequest(message: 'Missing required webhook payload fields');
    }

    const platformConfigRepo = PlatformPhonePeConfigRepository();
    final platformConfig = platformConfigRepo.getConfig();

    if (platformConfig?.webhookSecretKey case final secretKey?
        when secretKey.isNotEmpty) {
      final phonePeService = PhonePeService();
      final signatureHeader =
          context.request.headers['x-phonepe-checksum-signature'] ?? '';
      final isValid = phonePeService.verifyWebhookHmac(
        rawRequestBody: rawBody,
        signatureHeader: signatureHeader,
        secretKey: secretKey,
      );
      if (!isValid) {
        return badRequest(message: 'Invalid PhonePe HMAC checksum signature');
      }
    }

    if (merchantOrderId.startsWith('PFS_')) {
      final settlementId = merchantOrderId.substring(4);
      final gatewayState = PhonePeGatewayState.tryParse(state);

      if (gatewayState?.isSuccess ?? false) {
        const repo = PlatformFeeRepository();
        await repo.markSettlementCompleted(
          settlementId: settlementId,
          paymentTransactionId: transactionId,
        );
      }
    }

    return success(
      data: {'message': 'Platform fee webhook processed successfully'},
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
