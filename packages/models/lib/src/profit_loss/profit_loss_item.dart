import 'package:freezed_annotation/freezed_annotation.dart';

part 'profit_loss_item.freezed.dart';
part 'profit_loss_item.g.dart';

@freezed
abstract class ProfitLossItem with _$ProfitLossItem {
  const factory ProfitLossItem({
    required String productId,
    required String productName,
    required String categoryName,
    required String counterName,
    required int soldQuantity,
    required double costPrice,
    required double collectedPrice,
    required double profit,
    required double profitLossPercentage,
  }) = _ProfitLossItem;

  factory ProfitLossItem.fromJson(Map<String, Object?> json) =>
      _$ProfitLossItemFromJson(json);
}
