// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_platform_fee_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MerchantPlatformFeeSummary _$MerchantPlatformFeeSummaryFromJson(
  Map<String, dynamic> json,
) => _MerchantPlatformFeeSummary(
  unsettledAmountInPaise: (json['unsettledAmountInPaise'] as num).toInt(),
  unsettledOrdersCount: (json['unsettledOrdersCount'] as num).toInt(),
  recentSettlements:
      (json['recentSettlements'] as List<dynamic>?)
          ?.map(
            (e) => PlatformFeeSettlement.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$MerchantPlatformFeeSummaryToJson(
  _MerchantPlatformFeeSummary instance,
) => <String, dynamic>{
  'unsettledAmountInPaise': instance.unsettledAmountInPaise,
  'unsettledOrdersCount': instance.unsettledOrdersCount,
  'recentSettlements': instance.recentSettlements,
};
