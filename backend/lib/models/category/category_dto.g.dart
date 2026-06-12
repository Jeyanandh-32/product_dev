// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => _CategoryDto(
  id: json['id'] as String,
  name: json['name'] as String,
  merchantId: json['merchant_id'] as String,
  storeId: json['store_id'] as String,
  isActive: json['is_active'] as bool,
  createdAt: _fromJson(json['created_at'] as DateTime),
  updatedAt: _fromJson(json['updated_at'] as DateTime),
  description: json['description'] as String?,
  imageUrl: json['image_url'] as String?,
);

Map<String, dynamic> _$CategoryDtoToJson(_CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'merchant_id': instance.merchantId,
      'store_id': instance.storeId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'image_url': instance.imageUrl,
    };
