import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/payment_status.dart';
import 'package:models/src/subscription/subscription_payment_method.dart';
import 'package:models/src/subscription/subscription_plan_code.dart';

part 'subscription_transaction.freezed.dart';
part 'subscription_transaction.g.dart';

/// Transaction history log for subscription renewals/payments.
@freezed
abstract class SubscriptionTransaction with _$SubscriptionTransaction {
  const factory SubscriptionTransaction({
    required String id,
    required String storeId,
    required SubscriptionPlanCode planCode,
    required int amountInPaise,
    @Default('INR') String currency,
    required SubscriptionPaymentMethod paymentMethod,
    required PaymentStatus status,
    String? reference,
    DateTime? createdAt,
  }) = _SubscriptionTransaction;

  factory SubscriptionTransaction.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTransactionFromJson(json);
}
