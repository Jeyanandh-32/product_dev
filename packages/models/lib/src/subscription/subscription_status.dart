import 'package:freezed_annotation/freezed_annotation.dart';

/// Status lifecycle for a store subscription.
@JsonEnum(fieldRename: FieldRename.snake)
enum SubscriptionStatus {
  /// Store is in free trial mode.
  trial,

  /// Active paid subscription.
  active,

  /// In grace period (3 days after expiration) with warning banner.
  gracePeriod,

  /// Subscription has expired and checkout is blocked.
  expired,

  /// Subscription canceled by merchant or system.
  canceled;

  /// Whether the store is operational (can create orders).
  bool get isOperational =>
      this == trial || this == active || this == gracePeriod;

  /// Whether a warning banner should be displayed.
  bool get isWarning => this == gracePeriod || this == expired;

  /// Safe parser from string or wire value.
  static SubscriptionStatus? tryParse(String? value) {
    if (value == null) return null;
    final lower = value.toLowerCase().trim();
    if (lower == 'grace_period') return SubscriptionStatus.gracePeriod;
    return SubscriptionStatus.values.asNameMap()[lower];
  }

  /// Deserializes JSON string value.
  static SubscriptionStatus? fromJson(dynamic json) =>
      tryParse(json?.toString());
}
