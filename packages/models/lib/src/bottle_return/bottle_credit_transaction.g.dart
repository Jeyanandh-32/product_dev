// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_credit_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BottleCreditTransaction _$BottleCreditTransactionFromJson(
  Map<String, dynamic> json,
) => _BottleCreditTransaction(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  customerPhone: json['customerPhone'] as String,
  amount: (json['amount'] as num).toInt(),
  type: json['type'] as String,
  referenceOrderId: json['referenceOrderId'] as String?,
  storeId: json['storeId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BottleCreditTransactionToJson(
  _BottleCreditTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'merchantId': instance.merchantId,
  'customerPhone': instance.customerPhone,
  'amount': instance.amount,
  'type': instance.type,
  'referenceOrderId': instance.referenceOrderId,
  'storeId': instance.storeId,
  'createdAt': instance.createdAt?.toIso8601String(),
};
