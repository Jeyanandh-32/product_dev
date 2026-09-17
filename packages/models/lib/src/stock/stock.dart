import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';
part 'stock.g.dart';

/// Represents an inventory stock record for a product in a store.
@freezed
abstract class Stock with _$Stock {
  /// Creates a [Stock] record.
  const factory Stock({
    required String id,
    required String productId,
    required String storeId,
    required int quantity,
    required int lowStockThreshold,
    required bool stockMonitor,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Stock;

  /// Creates a [Stock] from a JSON map.
  factory Stock.fromJson(Map<String, Object?> json) => _$StockFromJson(json);
}
