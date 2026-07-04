import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({required Product product, required int quantity}) =
      _CartItem;

  factory CartItem.fromJson(Map<String, Object?> json) =>
      _$CartItemFromJson(json);
}
