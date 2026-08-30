// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_payment_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionPaymentSession _$SubscriptionPaymentSessionFromJson(
  Map<String, dynamic> json,
) => _SubscriptionPaymentSession(
  storeId: json['storeId'] as String,
  planCode: json['planCode'] as String,
  merchantTransactionId: json['merchantTransactionId'] as String,
  amountInPaise: (json['amountInPaise'] as num).toInt(),
  tokenUrl: json['tokenUrl'] as String,
  redirectUrl: json['redirectUrl'] as String?,
  orderId: json['orderId'] as String?,
);

Map<String, dynamic> _$SubscriptionPaymentSessionToJson(
  _SubscriptionPaymentSession instance,
) => <String, dynamic>{
  'storeId': instance.storeId,
  'planCode': instance.planCode,
  'merchantTransactionId': instance.merchantTransactionId,
  'amountInPaise': instance.amountInPaise,
  'tokenUrl': instance.tokenUrl,
  'redirectUrl': instance.redirectUrl,
  'orderId': instance.orderId,
};
