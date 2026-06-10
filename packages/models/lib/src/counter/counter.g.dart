// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Counter _$CounterFromJson(Map<String, dynamic> json) => _Counter(
  id: json['id'] as String,
  name: json['name'] as String,
  merchantId: json['merchantId'] as String,
  storeId: json['storeId'] as String,
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CounterToJson(_Counter instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'merchantId': instance.merchantId,
  'storeId': instance.storeId,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
