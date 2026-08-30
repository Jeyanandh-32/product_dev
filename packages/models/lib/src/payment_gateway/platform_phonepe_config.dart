import 'package:freezed_annotation/freezed_annotation.dart';

import 'payment_gateway_enums.dart';
import 'store_phonepe_config.dart';

part 'platform_phonepe_config.freezed.dart';
part 'platform_phonepe_config.g.dart';

/// Configuration for the developer/platform PhonePe payment gateway.
@freezed
abstract class PlatformPhonePeConfig with _$PlatformPhonePeConfig {
  const factory PlatformPhonePeConfig({
    required String id,
    @Default(true) bool isEnabled,
    @Default(PaymentGatewayEnv.uat) PaymentGatewayEnv env,
    String? clientId,
    String? clientVersion,
    String? clientSecret,
    String? saltKey,
    @Default(1) int saltIndex,
    @Default(true) bool enableUpi,
    @Default(true) bool enableCards,
    @Default(true) bool enableNetBanking,
    @Default(false) bool enableEmi,
    @Default(false) bool enableWallets,
    String? allowedUpiApps,
    @Default(WebhookAuthType.hmac) WebhookAuthType webhookAuthType,
    String? webhookSecretKey,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlatformPhonePeConfig;

  factory PlatformPhonePeConfig.fromJson(Map<String, Object?> json) =>
      _$PlatformPhonePeConfigFromJson(json);
}

/// Adapter extension to map platform configuration to store-specific PhonePe configuration.
extension PlatformPhonePeConfigAdapter on PlatformPhonePeConfig {
  /// Converts [PlatformPhonePeConfig] into a [StorePhonePeConfig] instance for [storeId].
  StorePhonePeConfig toStorePhonePeConfig({String storeId = ''}) =>
      StorePhonePeConfig(
        id: id,
        storeId: storeId,
        isEnabled: isEnabled,
        env: env,
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
        webhookAuthType: webhookAuthType,
        webhookSecretKey: webhookSecretKey,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
