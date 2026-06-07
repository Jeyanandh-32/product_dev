// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenPayload _$TokenPayloadFromJson(Map<String, dynamic> json) => TokenPayload(
  sub: json['sub'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
);

Map<String, dynamic> _$TokenPayloadToJson(TokenPayload instance) =>
    <String, dynamic>{
      'sub': instance.sub,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.merchant: 'merchant',
  UserRole.terminal: 'terminal',
};
