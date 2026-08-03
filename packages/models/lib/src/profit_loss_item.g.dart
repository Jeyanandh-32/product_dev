// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_loss_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfitLossItem _$ProfitLossItemFromJson(Map<String, dynamic> json) =>
    _ProfitLossItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      categoryName: json['categoryName'] as String,
      counterName: json['counterName'] as String,
      soldQuantity: (json['soldQuantity'] as num).toInt(),
      costPrice: (json['costPrice'] as num).toDouble(),
      collectedPrice: (json['collectedPrice'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      profitLossPercentage: (json['profitLossPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$ProfitLossItemToJson(_ProfitLossItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'categoryName': instance.categoryName,
      'counterName': instance.counterName,
      'soldQuantity': instance.soldQuantity,
      'costPrice': instance.costPrice,
      'collectedPrice': instance.collectedPrice,
      'profit': instance.profit,
      'profitLossPercentage': instance.profitLossPercentage,
    };
