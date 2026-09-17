import 'package:freezed_annotation/freezed_annotation.dart';

part 'profit_loss_item.freezed.dart';
part 'profit_loss_item.g.dart';

/// Represents a profit-and-loss metric breakdown for a specific product.
@freezed
abstract class ProfitLossItem with _$ProfitLossItem {
  /// Creates a [ProfitLossItem] instance.
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

  /// Creates a [ProfitLossItem] from a JSON map.
  factory ProfitLossItem.fromJson(Map<String, Object?> json) =>
      _$ProfitLossItemFromJson(json);
}
