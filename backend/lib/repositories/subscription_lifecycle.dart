import 'package:models/models.dart';

/// Helper utility for evaluating store subscription lifecycles and renewal date math.
abstract final class SubscriptionLifecycle {
  /// Default free trial duration in days.
  static const int trialDurationDays = 14;

  /// Default grace period duration in days after subscription expiration.
  static const int gracePeriodDays = 3;

  /// Calculates the active lifecycle status based on timestamps.
  static SubscriptionStatus evaluateStatus({
    required DateTime endsAt,
    required SubscriptionStatus currentStatus,
    required DateTime now,
    DateTime? graceEndsAt,
  }) {
    if (currentStatus == SubscriptionStatus.canceled) {
      return SubscriptionStatus.canceled;
    }

    final isPastEndsAt = now.isAfter(endsAt);
    final effectiveGraceEndsAt =
        graceEndsAt ?? endsAt.add(const Duration(days: gracePeriodDays));
    final isPastGrace = now.isAfter(effectiveGraceEndsAt);

    if (isPastGrace) {
      return SubscriptionStatus.expired;
    } else if (isPastEndsAt) {
      return SubscriptionStatus.gracePeriod;
    }
    return currentStatus;
  }

  /// Calculates new expiration and grace period end dates for plan renewal.
  static (DateTime endsAt, DateTime graceEndsAt) computeRenewalDates({
    required int planDurationDays,
    required DateTime now,
    DateTime? existingEndsAt,
  }) {
    final baseDate = (existingEndsAt != null && existingEndsAt.isAfter(now))
        ? existingEndsAt
        : now;
    final endsAt = baseDate.add(Duration(days: planDurationDays));
    final graceEndsAt = endsAt.add(const Duration(days: gracePeriodDays));
    return (endsAt, graceEndsAt);
  }
}
