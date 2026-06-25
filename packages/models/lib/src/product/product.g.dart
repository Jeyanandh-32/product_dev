// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  name: json['name'] as String,
  taxRate: (json['taxRate'] as num).toDouble(),
  basePrice: (json['basePrice'] as num).toInt(),
  sellingPrice: (json['sellingPrice'] as num).toInt(),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  categoryId: json['categoryId'] as String?,
  counterId: json['counterId'] as String?,
  sku: json['sku'] as String?,
  barcode: json['barcode'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  stock: json['stock'] == null
      ? null
      : Stock.fromJson(json['stock'] as Map<String, dynamic>),
  categoryName: json['categoryName'] as String?,
  counterName: json['counterName'] as String?,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'merchantId': instance.merchantId,
  'name': instance.name,
  'taxRate': instance.taxRate,
  'basePrice': instance.basePrice,
  'sellingPrice': instance.sellingPrice,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'categoryId': instance.categoryId,
  'counterId': instance.counterId,
  'sku': instance.sku,
  'barcode': instance.barcode,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'stock': instance.stock,
  'categoryName': instance.categoryName,
  'counterName': instance.counterName,
};
