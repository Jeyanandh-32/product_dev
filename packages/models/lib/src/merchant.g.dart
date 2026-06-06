// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Merchant _$MerchantFromJson(Map<String, dynamic> json) => Merchant(
  id: json['id'] as String,
  name: json['name'] as String,
  businessName: json['businessName'] as String,
  whatsappNumber: json['whatsappNumber'] as String,
  email: json['email'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'businessName': instance.businessName,
  'whatsappNumber': instance.whatsappNumber,
  'email': instance.email,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
