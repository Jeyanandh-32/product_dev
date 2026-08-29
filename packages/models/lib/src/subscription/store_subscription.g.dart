// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreSubscription _$StoreSubscriptionFromJson(Map<String, dynamic> json) =>
    _StoreSubscription(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      planCode: $enumDecode(_$SubscriptionPlanCodeEnumMap, json['planCode']),
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      graceEndsAt: json['graceEndsAt'] == null
          ? null
          : DateTime.parse(json['graceEndsAt'] as String),
      autoRenew: json['autoRenew'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StoreSubscriptionToJson(_StoreSubscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'planCode': _$SubscriptionPlanCodeEnumMap[instance.planCode]!,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'graceEndsAt': instance.graceEndsAt?.toIso8601String(),
      'autoRenew': instance.autoRenew,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SubscriptionPlanCodeEnumMap = {
  SubscriptionPlanCode.trial: 'trial',
  SubscriptionPlanCode.monthly: 'monthly',
  SubscriptionPlanCode.yearly: 'yearly',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.trial: 'trial',
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.gracePeriod: 'grace_period',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.canceled: 'canceled',
};
