import 'package:backend/repositories/subscription_lifecycle.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('SubscriptionLifecycle', () {
    test('evaluateStatus preserves canceled status', () {
      final now = DateTime.now();
      final status = SubscriptionLifecycle.evaluateStatus(
        endsAt: now.subtract(const Duration(days: 10)),
        currentStatus: SubscriptionStatus.canceled,
        now: now,
      );
      expect(status, SubscriptionStatus.canceled);
    });

    test('evaluateStatus returns active when not past endsAt', () {
      final now = DateTime.now();
      final status = SubscriptionLifecycle.evaluateStatus(
        endsAt: now.add(const Duration(days: 5)),
        currentStatus: SubscriptionStatus.active,
        now: now,
      );
      expect(status, SubscriptionStatus.active);
    });

    test('evaluateStatus returns gracePeriod when past endsAt but within grace window', () {
      final now = DateTime.now();
      final status = SubscriptionLifecycle.evaluateStatus(
        endsAt: now.subtract(const Duration(days: 1)),
        currentStatus: SubscriptionStatus.active,
        now: now,
        graceEndsAt: now.add(const Duration(days: 2)),
      );
      expect(status, SubscriptionStatus.gracePeriod);
    });

    test('evaluateStatus returns expired when past grace period', () {
      final now = DateTime.now();
      final status = SubscriptionLifecycle.evaluateStatus(
        endsAt: now.subtract(const Duration(days: 5)),
        currentStatus: SubscriptionStatus.gracePeriod,
        now: now,
        graceEndsAt: now.subtract(const Duration(days: 2)),
      );
      expect(status, SubscriptionStatus.expired);
    });

    test('computeRenewalDates calculates correct future dates from now when existing expired', () {
      final now = DateTime(2026);
      final (endsAt, graceEndsAt) = SubscriptionLifecycle.computeRenewalDates(
        planDurationDays: 30,
        now: now,
        existingEndsAt: DateTime(2025, 12),
      );
      expect(endsAt, DateTime(2026, 1, 31));
      expect(graceEndsAt, DateTime(2026, 2, 3));
    });

    test('computeRenewalDates calculates extended dates from existing endsAt when active', () {
      final now = DateTime(2026);
      final existingEndsAt = DateTime(2026, 1, 15);
      final (endsAt, graceEndsAt) = SubscriptionLifecycle.computeRenewalDates(
        planDurationDays: 30,
        now: now,
        existingEndsAt: existingEndsAt,
      );
      expect(endsAt, DateTime(2026, 2, 14));
      expect(graceEndsAt, DateTime(2026, 2, 17));
    });
  });
}
