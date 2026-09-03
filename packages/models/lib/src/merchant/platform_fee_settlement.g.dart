// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_fee_settlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlatformFeeSettlement _$PlatformFeeSettlementFromJson(
  Map<String, dynamic> json,
) => _PlatformFeeSettlement(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  amountInPaise: (json['amountInPaise'] as num).toInt(),
  ordersCount: (json['ordersCount'] as num?)?.toInt() ?? 0,
  paymentGateway: json['paymentGateway'] as String? ?? 'phonepe',
  paymentTransactionId: json['paymentTransactionId'] as String?,
  status: json['status'] as String? ?? 'pending',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  settledAt: json['settledAt'] == null
      ? null
      : DateTime.parse(json['settledAt'] as String),
);

Map<String, dynamic> _$PlatformFeeSettlementToJson(
  _PlatformFeeSettlement instance,
) => <String, dynamic>{
  'id': instance.id,
  'merchantId': instance.merchantId,
  'amountInPaise': instance.amountInPaise,
  'ordersCount': instance.ordersCount,
  'paymentGateway': instance.paymentGateway,
  'paymentTransactionId': instance.paymentTransactionId,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'settledAt': instance.settledAt?.toIso8601String(),
};
