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
  discountAmount: (json['discountAmount'] as num).toDouble(),
  paidAmount: (json['paidAmount'] as num).toDouble(),
  paymentMode: $enumDecode(_$PaymentMethodEnumMap, json['paymentMode']),
  paymentStatus: $enumDecode(
    _$PaymentStatusEnumMap,
    json['paymentStatus'],
    unknownValue: PaymentStatus.paid,
  ),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'orderReference': instance.orderReference,
  'orderId': instance.orderId,
  'orderAmount': instance.orderAmount,
  'discountAmount': instance.discountAmount,
  'paidAmount': instance.paidAmount,
  'paymentMode': _$PaymentMethodEnumMap[instance.paymentMode]!,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'date': instance.date.toIso8601String(),
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.upi: 'upi',
  PaymentMethod.complimentary: 'complimentary',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.unpaid: 'unpaid',
  PaymentStatus.paid: 'paid',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.cancelled: 'cancelled',
};
