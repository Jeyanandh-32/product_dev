import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderReference,
    required String orderId,
    required double orderAmount,
    required double discountAmount,
    required double paidAmount,
    required PaymentMethod paymentMode,
    @JsonKey(unknownEnumValue: PaymentStatus.pending)
    required PaymentStatus paymentStatus,
    required DateTime date,
  }) = _Payment;

  factory Payment.fromJson(Map<String, Object?> json) =>
      _$PaymentFromJson(json);
}
