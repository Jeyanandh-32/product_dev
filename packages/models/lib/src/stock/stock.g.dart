// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stock _$StockFromJson(Map<String, dynamic> json) => _Stock(
  id: json['id'] as String,
  productId: json['productId'] as String,
  storeId: json['storeId'] as String,
  quantity: (json['quantity'] as num).toInt(),
  lowStockThreshold: (json['lowStockThreshold'] as num).toInt(),
  stockMonitor: json['stockMonitor'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$StockToJson(_Stock instance) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'storeId': instance.storeId,
  'quantity': instance.quantity,
  'lowStockThreshold': instance.lowStockThreshold,
  'stockMonitor': instance.stockMonitor,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
