import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension StorePhonePeConfigRowExtension on StorePhonePeConfigRow {
  StorePhonePeConfig toStorePhonePeConfig() => StorePhonePeConfig(
        id: id,
        storeId: storeId,
        isEnabled: isEnabled,
        env: PaymentGatewayEnv.values.firstWhere(
          (e) => e.name.toUpperCase() == env.toUpperCase(),
          orElse: () => PaymentGatewayEnv.uat,
        ),
        clientId: clientId,
        clientVersion: clientVersion,
        clientSecret: clientSecret,
        saltKey: saltKey,
        saltIndex: saltIndex,
        enableUpi: enableUpi,
        enableCards: enableCards,
        enableNetBanking: enableNetBanking,
        enableEmi: enableEmi,
        enableWallets: enableWallets,
        allowedUpiApps: allowedUpiApps,
        webhookAuthType: WebhookAuthType.values.firstWhere(
          (a) => a.name.toUpperCase() == webhookAuthType.toUpperCase(),
          orElse: () => WebhookAuthType.hmac,
        ),
        webhookSecretKey: webhookSecretKey,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
