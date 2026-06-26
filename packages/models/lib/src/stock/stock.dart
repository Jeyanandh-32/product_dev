import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';
part 'stock.g.dart';

@freezed
abstract class Stock with _$Stock {
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

  factory Stock.fromJson(Map<String, Object?> json) =>
      _$StockFromJson(json);
}
