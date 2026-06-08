// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Terminal _$TerminalFromJson(Map<String, dynamic> json) => _Terminal(
  code: json['code'] as String,
  merchantId: json['merchantId'] as String,
  storeId: json['storeId'] as String,
  name: json['name'] as String,
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TerminalToJson(_Terminal instance) => <String, dynamic>{
  'code': instance.code,
  'merchantId': instance.merchantId,
  'storeId': instance.storeId,
  'name': instance.name,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
