import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String merchantId,
    required String storeId,
    required String orderReference,
    required int billNo,
    required OrderSource source,
    required OrderType type,
    required OrderStatus status,
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double taxTotal,
    required double grandTotal,
    String? terminalCode,
    required List<OrderItem> items,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
}
