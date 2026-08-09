// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MerchantSettings _$MerchantSettingsFromJson(Map<String, dynamic> json) =>
    _MerchantSettings(
      merchantId: json['merchantId'] as String,
      waNotifications: json['waNotifications'] as bool? ?? true,
      lowStockAlerts: json['lowStockAlerts'] as bool? ?? true,
      dailyReports: json['dailyReports'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MerchantSettingsToJson(_MerchantSettings instance) =>
    <String, dynamic>{
      'merchantId': instance.merchantId,
      'waNotifications': instance.waNotifications,
      'lowStockAlerts': instance.lowStockAlerts,
      'dailyReports': instance.dailyReports,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
