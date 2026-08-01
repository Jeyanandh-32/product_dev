// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  storeId: json['storeId'] as String,
  orderReference: json['orderReference'] as String,
  billNo: (json['billNo'] as num).toInt(),
  source: $enumDecode(_$OrderSourceEnumMap, json['source']),
  type: $enumDecode(_$OrderTypeEnumMap, json['type']),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
  paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
  subtotal: (json['subtotal'] as num).toDouble(),
  discountTotal: (json['discountTotal'] as num?)?.toDouble() ?? 0.0,
  taxTotal: (json['taxTotal'] as num).toDouble(),
  grandTotal: (json['grandTotal'] as num).toDouble(),
  terminalCode: json['terminalCode'] as String?,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'merchantId': instance.merchantId,
  'storeId': instance.storeId,
  'orderReference': instance.orderReference,
  'billNo': instance.billNo,
  'source': _$OrderSourceEnumMap[instance.source]!,
  'type': _$OrderTypeEnumMap[instance.type]!,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'subtotal': instance.subtotal,
  'discountTotal': instance.discountTotal,
  'taxTotal': instance.taxTotal,
  'grandTotal': instance.grandTotal,
  'terminalCode': instance.terminalCode,
  'items': instance.items,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$OrderSourceEnumMap = {
  OrderSource.terminal: 'terminal',
  OrderSource.web: 'web',
  OrderSource.mobileApp: 'mobileApp',
};

const _$OrderTypeEnumMap = {
  OrderType.dineIn: 'dineIn',
  OrderType.takeaway: 'takeaway',
  OrderType.delivery: 'delivery',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.preparing: 'preparing',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.unpaid: 'unpaid',
  PaymentStatus.paid: 'paid',
  PaymentStatus.complimentary: 'complimentary',
  PaymentStatus.refunded: 'refunded',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.upi: 'upi',
  PaymentMethod.complimentary: 'complimentary',
};
