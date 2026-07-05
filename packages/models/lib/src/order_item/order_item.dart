import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String productId,
    required Product? product,
    required String storeId,
    required int quantity,
    required double unitPrice,
    required double taxRate,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, Object?> json) =>
      _$OrderItemFromJson(json);
}
