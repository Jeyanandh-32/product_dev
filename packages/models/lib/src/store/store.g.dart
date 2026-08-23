// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Store _$StoreFromJson(Map<String, dynamic> json) => _Store(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  storeType: json['storeType'] as String?,
  isActive: json['isActive'] as bool,
  isOnlineEnabled: json['isOnlineEnabled'] as bool? ?? false,
  isBottleReturnEnabled: json['isBottleReturnEnabled'] as bool? ?? false,
  activePaymentProvider:
      $enumDecodeNullable(
        _$PaymentProviderEnumMap,
        json['activePaymentProvider'],
      ) ??
      PaymentProvider.phonepe,
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$StoreToJson(_Store instance) => <String, dynamic>{
  'id': instance.id,
  'merchantId': instance.merchantId,
  'name': instance.name,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'storeType': instance.storeType,
  'isActive': instance.isActive,
  'isOnlineEnabled': instance.isOnlineEnabled,
  'isBottleReturnEnabled': instance.isBottleReturnEnabled,
  'activePaymentProvider':
      _$PaymentProviderEnumMap[instance.activePaymentProvider],
  'slug': instance.slug,
};

const _$PaymentProviderEnumMap = {
  PaymentProvider.phonepe: 'phonepe',
  PaymentProvider.cashfree: 'cashfree',
  PaymentProvider.razorpay: 'razorpay',
};
