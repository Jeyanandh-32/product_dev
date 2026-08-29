import 'package:freezed_annotation/freezed_annotation.dart';

/// Supported subscription plan tier codes.
@JsonEnum(fieldRename: FieldRename.snake)
enum SubscriptionPlanCode {
  /// 14-day free trial on store creation.
  trial,

  /// Flat monthly pro subscription.
  monthly,

  /// Flat yearly pro subscription with 2 months free discount.
  yearly;

  /// Safe parser from string identifier.
  static SubscriptionPlanCode? tryParse(String? value) =>
      SubscriptionPlanCode.values.asNameMap()[value?.toLowerCase().trim()];
}
