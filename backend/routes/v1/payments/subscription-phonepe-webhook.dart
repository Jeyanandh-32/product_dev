import 'dart:convert';

import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/platform_phonepe_config_repository.dart';
import 'package:backend/repositories/subscription_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;

/// Public webhook receiver for PhonePe subscription payment notifications.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .post => _onPost(context),
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

    if (merchantOrderId == null || state == null) {
      return badRequest(message: 'Missing required webhook payload fields');
    }

    final db = Database.db;
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

    final subRepo = SubscriptionRepository(db: db);
    final txList = await db.subscriptionTransactions
        .where((t) => t.reference.equals(toExpr(merchantOrderId)))
        .fetch();
    final tx = txList.firstOrNull;

    if (tx == null) {
      return notFound(message: 'Transaction not found');
    }

    final gatewayState = PhonePeGatewayState.fromJson(state);

    if (gatewayState?.isSuccess ?? false) {
      final planCode =
          SubscriptionPlanCode.tryParse(tx.planCode) ??
          SubscriptionPlanCode.monthly;

      await subRepo.renewSubscription(
        storeId: tx.storeId,
        planCode: planCode,
        paymentMethod: SubscriptionPaymentMethod.phonepe,
        reference: merchantOrderId,
      );
    } else if (gatewayState?.isFailed ?? false) {
      await db.subscriptionTransactions
          .byKey(tx.id)
          .update((t, set) => set(status: toExpr(PaymentStatus.failed.name)))
          .execute();
    }

    return success(
      data: {'message': 'Subscription webhook processed successfully'},
    );
  } catch (e) {
    return error(message: e.toString());
  }
}
