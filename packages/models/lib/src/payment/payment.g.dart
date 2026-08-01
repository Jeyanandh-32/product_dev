// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  orderReference: json['orderReference'] as String,
  orderId: json['orderId'] as String,
  orderAmount: (json['orderAmount'] as num).toDouble(),
  paidAmount: (json['paidAmount'] as num).toDouble(),
  paymentMode: $enumDecode(_$PaymentMethodEnumMap, json['paymentMode']),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'orderReference': instance.orderReference,
  'orderId': instance.orderId,
  'orderAmount': instance.orderAmount,
  'paidAmount': instance.paidAmount,
  'paymentMode': _$PaymentMethodEnumMap[instance.paymentMode]!,
  'date': instance.date.toIso8601String(),
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.upi: 'upi',
};
