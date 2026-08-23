// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_return_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BottleReturnConfig _$BottleReturnConfigFromJson(Map<String, dynamic> json) =>
    _BottleReturnConfig(
      storeId: json['storeId'] as String,
      isEnabled: json['isEnabled'] as bool? ?? true,
      rewardAmountInRupees:
          (json['rewardAmountInRupees'] as num?)?.toInt() ?? 10,
      iotApiKey: json['iotApiKey'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BottleReturnConfigToJson(_BottleReturnConfig instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'isEnabled': instance.isEnabled,
      'rewardAmountInRupees': instance.rewardAmountInRupees,
      'iotApiKey': instance.iotApiKey,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
