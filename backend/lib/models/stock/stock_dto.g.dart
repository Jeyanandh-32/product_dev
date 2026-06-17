// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockDto _$StockDtoFromJson(Map<String, dynamic> json) => _StockDto(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  storeId: json['store_id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  lowStockThreshold: (json['low_stock_threshold'] as num).toInt(),
  createdAt: dateTimeFromJson(json['created_at'] as DateTime),
  updatedAt: dateTimeFromJson(json['updated_at'] as DateTime),
);

Map<String, dynamic> _$StockDtoToJson(_StockDto instance) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'store_id': instance.storeId,
  'quantity': instance.quantity,
  'low_stock_threshold': instance.lowStockThreshold,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
