import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:terminal/components/common/subscription_banner.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  final now = DateTime(2026, 1, 1);

  group('SubscriptionBanner Widget Tests', () {
    testWidgets('renders nothing when subscription is active or trial', (
      tester,
    ) async {
      final activeSub = StoreSubscription(
        id: 'sub-1',
        storeId: 's-1',
        planCode: SubscriptionPlanCode.monthly,
        status: SubscriptionStatus.active,
        startsAt: now,
        endsAt: now.add(const Duration(days: 30)),
      );

      await tester.pumpWidget(_wrap(SubscriptionBanner(subscription: activeSub)));
      expect(find.byType(SubscriptionBanner), findsOneWidget);
      expect(find.text('Store Subscription Expired — Billing Locked'), findsNothing);
      expect(find.text('Subscription Grace Period (3 Days Remaining)'), findsNothing);
    });

    testWidgets('renders warning banner when subscription is in gracePeriod', (
      tester,
    ) async {
      final graceSub = StoreSubscription(
        id: 'sub-1',
        storeId: 's-1',
        planCode: SubscriptionPlanCode.monthly,
        status: SubscriptionStatus.gracePeriod,
        startsAt: now,
        endsAt: now.subtract(const Duration(days: 1)),
        graceEndsAt: now.add(const Duration(days: 2)),
      );

      await tester.pumpWidget(_wrap(SubscriptionBanner(subscription: graceSub)));
      expect(find.text('Subscription Grace Period (3 Days Remaining)'), findsOneWidget);
    });

    testWidgets('renders locked alert when subscription is expired', (
      tester,
    ) async {
      final expiredSub = StoreSubscription(
        id: 'sub-1',
        storeId: 's-1',
        planCode: SubscriptionPlanCode.monthly,
        status: SubscriptionStatus.expired,
        startsAt: now.subtract(const Duration(days: 40)),
        endsAt: now.subtract(const Duration(days: 10)),
      );

      await tester.pumpWidget(_wrap(SubscriptionBanner(subscription: expiredSub)));
      expect(find.text('Store Subscription Expired — Billing Locked'), findsOneWidget);
    });
  });
}
