// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_summary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockSummaryItem _$StockSummaryItemFromJson(Map<String, dynamic> json) =>
    _StockSummaryItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      categoryName: json['categoryName'] as String,
      counterName: json['counterName'] as String,
      openingStock: (json['openingStock'] as num).toInt(),
      inQuantity: (json['inQuantity'] as num).toInt(),
      outQuantity: (json['outQuantity'] as num).toInt(),
      wastageQuantity: (json['wastageQuantity'] as num).toInt(),
      adjustmentQuantity: (json['adjustmentQuantity'] as num).toInt(),
      closingStock: (json['closingStock'] as num).toInt(),
    );

Map<String, dynamic> _$StockSummaryItemToJson(_StockSummaryItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'categoryName': instance.categoryName,
      'counterName': instance.counterName,
      'openingStock': instance.openingStock,
      'inQuantity': instance.inQuantity,
      'outQuantity': instance.outQuantity,
      'wastageQuantity': instance.wastageQuantity,
      'adjustmentQuantity': instance.adjustmentQuantity,
      'closingStock': instance.closingStock,
    };
