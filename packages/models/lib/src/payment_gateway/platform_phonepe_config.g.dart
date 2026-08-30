// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_phonepe_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlatformPhonePeConfig _$PlatformPhonePeConfigFromJson(
  Map<String, dynamic> json,
) => _PlatformPhonePeConfig(
  id: json['id'] as String,
  isEnabled: json['isEnabled'] as bool? ?? true,
  env:
      $enumDecodeNullable(_$PaymentGatewayEnvEnumMap, json['env']) ??
      PaymentGatewayEnv.uat,
  clientId: json['clientId'] as String?,
  clientVersion: json['clientVersion'] as String?,
  clientSecret: json['clientSecret'] as String?,
  saltKey: json['saltKey'] as String?,
  saltIndex: (json['saltIndex'] as num?)?.toInt() ?? 1,
  enableUpi: json['enableUpi'] as bool? ?? true,
  enableCards: json['enableCards'] as bool? ?? true,
  enableNetBanking: json['enableNetBanking'] as bool? ?? true,
  enableEmi: json['enableEmi'] as bool? ?? false,
  enableWallets: json['enableWallets'] as bool? ?? false,
  allowedUpiApps: json['allowedUpiApps'] as String?,
  webhookAuthType:
      $enumDecodeNullable(_$WebhookAuthTypeEnumMap, json['webhookAuthType']) ??
      WebhookAuthType.hmac,
  webhookSecretKey: json['webhookSecretKey'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PlatformPhonePeConfigToJson(
  _PlatformPhonePeConfig instance,
) => <String, dynamic>{
  'id': instance.id,
  'isEnabled': instance.isEnabled,
  'env': _$PaymentGatewayEnvEnumMap[instance.env]!,
  'clientId': instance.clientId,
  'clientVersion': instance.clientVersion,
  'clientSecret': instance.clientSecret,
  'saltKey': instance.saltKey,
  'saltIndex': instance.saltIndex,
  'enableUpi': instance.enableUpi,
  'enableCards': instance.enableCards,
  'enableNetBanking': instance.enableNetBanking,
  'enableEmi': instance.enableEmi,
  'enableWallets': instance.enableWallets,
  'allowedUpiApps': instance.allowedUpiApps,
  'webhookAuthType': _$WebhookAuthTypeEnumMap[instance.webhookAuthType]!,
  'webhookSecretKey': instance.webhookSecretKey,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$PaymentGatewayEnvEnumMap = {
  PaymentGatewayEnv.uat: 'UAT',
  PaymentGatewayEnv.prod: 'PROD',
};

const _$WebhookAuthTypeEnumMap = {
  WebhookAuthType.hmac: 'HMAC',
  WebhookAuthType.bearer: 'BEARER',
  WebhookAuthType.basic: 'BASIC',
};
