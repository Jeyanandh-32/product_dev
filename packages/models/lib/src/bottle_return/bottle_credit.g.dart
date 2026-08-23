// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_credit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BottleCredit _$BottleCreditFromJson(Map<String, dynamic> json) =>
    _BottleCredit(
      id: json['id'] as String,
      merchantId: json['merchantId'] as String,
      customerPhone: json['customerPhone'] as String,
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BottleCreditToJson(_BottleCredit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchantId': instance.merchantId,
      'customerPhone': instance.customerPhone,
      'balance': instance.balance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
