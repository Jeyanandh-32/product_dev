// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionTransaction _$SubscriptionTransactionFromJson(
  Map<String, dynamic> json,
) => _SubscriptionTransaction(
  id: json['id'] as String,
  storeId: json['storeId'] as String,
  planCode: $enumDecode(_$SubscriptionPlanCodeEnumMap, json['planCode']),
  amountInPaise: (json['amountInPaise'] as num).toInt(),
  currency: json['currency'] as String? ?? 'INR',
  paymentMethod: $enumDecode(
    _$SubscriptionPaymentMethodEnumMap,
    json['paymentMethod'],
  ),
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
  reference: json['reference'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$SubscriptionTransactionToJson(
  _SubscriptionTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'storeId': instance.storeId,
  'planCode': _$SubscriptionPlanCodeEnumMap[instance.planCode]!,
  'amountInPaise': instance.amountInPaise,
  'currency': instance.currency,
  'paymentMethod': _$SubscriptionPaymentMethodEnumMap[instance.paymentMethod]!,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'reference': instance.reference,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$SubscriptionPlanCodeEnumMap = {
  SubscriptionPlanCode.trial: 'trial',
  SubscriptionPlanCode.monthly: 'monthly',
  SubscriptionPlanCode.yearly: 'yearly',
};

const _$SubscriptionPaymentMethodEnumMap = {
  SubscriptionPaymentMethod.simulated: 'simulated',
  SubscriptionPaymentMethod.phonepe: 'phonepe',
  SubscriptionPaymentMethod.manual: 'manual',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.completed: 'completed',
  PaymentStatus.pending: 'pending',
  PaymentStatus.failed: 'failed',
};
