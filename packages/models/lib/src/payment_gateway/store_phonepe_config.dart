import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_gateway_enums.dart';

part 'store_phonepe_config.freezed.dart';
part 'store_phonepe_config.g.dart';

/// Store-specific merchant credentials and configuration for PhonePe PG integration.
@freezed
abstract class StorePhonePeConfig with _$StorePhonePeConfig {
  /// Creates a [StorePhonePeConfig] instance.
  const factory StorePhonePeConfig({
    required String id,
    required String storeId,
    @Default(true) bool isEnabled,
    @Default(PaymentGatewayEnv.uat) PaymentGatewayEnv env,
    String? clientId,
    String? clientVersion,
    String? clientSecret,
    String? saltKey,
    @Default(1) int saltIndex,
    @Default(true) bool enableUpi,
    @Default(false) bool enableCards,
    @Default(false) bool enableNetBanking,
    @Default(false) bool enableEmi,
    @Default(false) bool enableWallets,
    String? allowedUpiApps,
    @Default(WebhookAuthType.hmac) WebhookAuthType webhookAuthType,
    String? webhookSecretKey,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StorePhonePeConfig;

  /// Creates a [StorePhonePeConfig] from a JSON map.
  factory StorePhonePeConfig.fromJson(Map<String, Object?> json) =>
      _$StorePhonePeConfigFromJson(json);
}
