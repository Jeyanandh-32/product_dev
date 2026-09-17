import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

/// Represents an individual item line in an order.
@freezed
abstract class OrderItem with _$OrderItem {
  /// Creates an [OrderItem].
  const factory OrderItem({
    required String id,
    required String productId,
    required Product? product,
    required String storeId,
    required int quantity,
    required double unitPrice,
    @Default(0.0) double discount,
    required double taxRate,
  }) = _OrderItem;

  /// Creates an [OrderItem] from a JSON map.
  factory OrderItem.fromJson(Map<String, Object?> json) =>
      _$OrderItemFromJson(json);
}
