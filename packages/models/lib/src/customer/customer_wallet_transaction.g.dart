// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_wallet_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerWalletTransaction _$CustomerWalletTransactionFromJson(
  Map<String, dynamic> json,
) => _CustomerWalletTransaction(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: $enumDecode(_$WalletTransactionTypeEnumMap, json['type']),
  reference: json['reference'] as String?,
  status: json['status'] as String,
  platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
  gatewayCharges: (json['gatewayCharges'] as num?)?.toDouble() ?? 0.0,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CustomerWalletTransactionToJson(
  _CustomerWalletTransaction instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerId': instance.customerId,
  'amount': instance.amount,
  'type': _$WalletTransactionTypeEnumMap[instance.type]!,
  'reference': instance.reference,
  'status': instance.status,
  'platformFee': instance.platformFee,
  'gatewayCharges': instance.gatewayCharges,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$WalletTransactionTypeEnumMap = {
  WalletTransactionType.topUp: 'topUp',
  WalletTransactionType.orderDebit: 'orderDebit',
  WalletTransactionType.refundCredit: 'refundCredit',
};
