import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_payment_session.freezed.dart';
part 'subscription_payment_session.g.dart';

/// Represents an active PhonePe checkout payment session for a store subscription.
@freezed
abstract class SubscriptionPaymentSession with _$SubscriptionPaymentSession {
  const factory SubscriptionPaymentSession({
    required String storeId,
    required String planCode,
    required String merchantTransactionId,
    required int amountInPaise,
    required String tokenUrl,
    String? redirectUrl,
    String? orderId,
  }) = _SubscriptionPaymentSession;

  factory SubscriptionPaymentSession.fromJson(Map<String, Object?> json) =>
      _$SubscriptionPaymentSessionFromJson(json);
}
