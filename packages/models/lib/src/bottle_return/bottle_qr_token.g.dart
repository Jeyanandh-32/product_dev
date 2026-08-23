// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_qr_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BottleQrToken _$BottleQrTokenFromJson(Map<String, dynamic> json) =>
    _BottleQrToken(
      id: json['id'] as String,
      token: json['token'] as String,
      merchantId: json['merchantId'] as String,
      storeId: json['storeId'] as String,
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      rewardMode:
          $enumDecodeNullable(_$BottleRewardModeEnumMap, json['rewardMode']) ??
          BottleRewardMode.digital,
      customerPhone: json['customerPhone'] as String?,
      status:
          $enumDecodeNullable(_$BottleTokenStatusEnumMap, json['status']) ??
          BottleTokenStatus.active,
      returnedAt: json['returnedAt'] == null
          ? null
          : DateTime.parse(json['returnedAt'] as String),
      returnedStoreId: json['returnedStoreId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BottleQrTokenToJson(_BottleQrToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'merchantId': instance.merchantId,
      'storeId': instance.storeId,
      'orderId': instance.orderId,
      'productId': instance.productId,
      'rewardMode': _$BottleRewardModeEnumMap[instance.rewardMode]!,
      'customerPhone': instance.customerPhone,
      'status': _$BottleTokenStatusEnumMap[instance.status]!,
      'returnedAt': instance.returnedAt?.toIso8601String(),
      'returnedStoreId': instance.returnedStoreId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$BottleRewardModeEnumMap = {
  BottleRewardMode.digital: 'digital',
  BottleRewardMode.physical: 'physical',
};

const _$BottleTokenStatusEnumMap = {
  BottleTokenStatus.active: 'active',
  BottleTokenStatus.returned: 'returned',
  BottleTokenStatus.voided: 'voided',
};
