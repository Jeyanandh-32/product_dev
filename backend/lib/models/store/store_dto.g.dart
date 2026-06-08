// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) => _StoreDto(
  id: json['id'] as String,
  merchantId: json['merchant_id'] as String,
  name: json['name'] as String,
  createdAt: _fromJson(json['created_at'] as DateTime),
  updatedAt: _fromJson(json['updated_at'] as DateTime),
  isActive: json['is_active'] as bool,
  storeType: json['store_type'] as String?,
);

Map<String, dynamic> _$StoreDtoToJson(_StoreDto instance) => <String, dynamic>{
  'id': instance.id,
  'merchant_id': instance.merchantId,
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'is_active': instance.isActive,
  'store_type': instance.storeType,
};
