// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TerminalDto _$TerminalDtoFromJson(Map<String, dynamic> json) => _TerminalDto(
  code: json['code'] as String,
  merchantId: json['merchant_id'] as String,
  storeId: json['store_id'] as String,
  name: json['name'] as String,
  passwordHash: json['password_hash'] as String,
  isActive: json['is_active'] as bool,
  createdAt: dateTimeFromJson(json['created_at'] as DateTime),
  updatedAt: dateTimeFromJson(json['updated_at'] as DateTime),
);

Map<String, dynamic> _$TerminalDtoToJson(_TerminalDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'merchant_id': instance.merchantId,
      'store_id': instance.storeId,
      'name': instance.name,
      'password_hash': instance.passwordHash,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
