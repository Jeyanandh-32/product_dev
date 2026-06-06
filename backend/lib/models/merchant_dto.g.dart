// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantDto _$MerchantDtoFromJson(Map<String, dynamic> json) => MerchantDto(
  id: json['id'] as String,
  name: json['name'] as String,
  businessName: json['business_name'] as String,
  whatsappNumber: json['whatsapp_number'] as String,
  email: json['email'] as String,
  passwordHash: json['password_hash'] as String,
  createdAt: MerchantDto._fromJson(json['created_at'] as DateTime),
  updatedAt: MerchantDto._fromJson(json['updated_at'] as DateTime),
);

Map<String, dynamic> _$MerchantDtoToJson(MerchantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'business_name': instance.businessName,
      'whatsapp_number': instance.whatsappNumber,
      'email': instance.email,
      'password_hash': instance.passwordHash,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
