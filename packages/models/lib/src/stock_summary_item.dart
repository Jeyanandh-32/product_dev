import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_summary_item.freezed.dart';
part 'stock_summary_item.g.dart';

@freezed
abstract class StockSummaryItem with _$StockSummaryItem {
  const factory StockSummaryItem({
    required String productId,
    required String productName,
    required String categoryName,
    required String counterName,
    required int openingStock,
    required int inQuantity,
    required int outQuantity,
    required int wastageQuantity,
    required int adjustmentQuantity,
    required int closingStock,
  }) = _StockSummaryItem;

  factory StockSummaryItem.fromJson(Map<String, Object?> json) =>
      _$StockSummaryItemFromJson(json);
}
