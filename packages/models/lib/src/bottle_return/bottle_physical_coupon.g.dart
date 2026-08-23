// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_physical_coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BottlePhysicalCoupon _$BottlePhysicalCouponFromJson(
  Map<String, dynamic> json,
) => _BottlePhysicalCoupon(
  id: json['id'] as String,
  code: json['code'] as String,
  merchantId: json['merchantId'] as String,
  storeId: json['storeId'] as String,
  amount: (json['amount'] as num).toInt(),
  status: json['status'] as String? ?? 'active',
  redeemedAt: json['redeemedAt'] == null
      ? null
      : DateTime.parse(json['redeemedAt'] as String),
  redeemedOrderId: json['redeemedOrderId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BottlePhysicalCouponToJson(
  _BottlePhysicalCoupon instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'merchantId': instance.merchantId,
  'storeId': instance.storeId,
  'amount': instance.amount,
  'status': instance.status,
  'redeemedAt': instance.redeemedAt?.toIso8601String(),
  'redeemedOrderId': instance.redeemedOrderId,
  'createdAt': instance.createdAt?.toIso8601String(),
};
