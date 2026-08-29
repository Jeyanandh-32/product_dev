// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
    _SubscriptionPlan(
      code: $enumDecode(_$SubscriptionPlanCodeEnumMap, json['code']),
      name: json['name'] as String,
      priceInPaise: (json['priceInPaise'] as num).toInt(),
      currency: json['currency'] as String? ?? 'INR',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 30,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SubscriptionPlanToJson(_SubscriptionPlan instance) =>
    <String, dynamic>{
      'code': _$SubscriptionPlanCodeEnumMap[instance.code]!,
      'name': instance.name,
      'priceInPaise': instance.priceInPaise,
      'currency': instance.currency,
      'durationDays': instance.durationDays,
      'features': instance.features,
    };

const _$SubscriptionPlanCodeEnumMap = {
  SubscriptionPlanCode.trial: 'trial',
  SubscriptionPlanCode.monthly: 'monthly',
  SubscriptionPlanCode.yearly: 'yearly',
};
