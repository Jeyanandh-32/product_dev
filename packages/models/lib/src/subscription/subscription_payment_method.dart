import 'package:freezed_annotation/freezed_annotation.dart';

/// Payment method used for subscription renewal transactions.
@JsonEnum(fieldRename: FieldRename.snake)
enum SubscriptionPaymentMethod {
  /// Simulated payment for test/development environments.
  simulated,

  /// PhonePe payment gateway.
  phonepe,

  /// Manual bank transfer or admin activation.
  manual;

  /// Safe parser from string identifier.
  static SubscriptionPaymentMethod? tryParse(String? value) =>
      SubscriptionPaymentMethod.values.asNameMap()[value?.toLowerCase().trim()];
}
