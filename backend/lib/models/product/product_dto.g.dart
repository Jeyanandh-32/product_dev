// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => _ProductDto(
  id: json['id'] as String,
  merchantId: json['merchant_id'] as String,
  name: json['name'] as String,
  taxRate: doubleFromJson(json['tax_rate']),
  basePrice: (json['base_price'] as num).toInt(),
  sellingPrice: (json['selling_price'] as num).toInt(),
  isActive: json['is_active'] as bool,
  createdAt: dateTimeFromJson(json['created_at'] as DateTime),
  updatedAt: dateTimeFromJson(json['updated_at'] as DateTime),
  sku: json['sku'] as String?,
  barcode: json['barcode'] as String?,
  description: json['description'] as String?,
  imageUrl: json['image_url'] as String?,
  stock: json['stock'] == null
      ? null
      : StockDto.fromJson(json['stock'] as Map<String, dynamic>),
  category: json['category'] == null
      ? null
      : CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
  counter: json['counter'] == null
      ? null
      : CounterDto.fromJson(json['counter'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductDtoToJson(_ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchant_id': instance.merchantId,
      'name': instance.name,
      'tax_rate': instance.taxRate,
      'base_price': instance.basePrice,
      'selling_price': instance.sellingPrice,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'sku': instance.sku,
      'barcode': instance.barcode,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'stock': instance.stock,
      'category': instance.category,
      'counter': instance.counter,
    };
