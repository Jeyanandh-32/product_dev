import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/account/account_hero_avatar.dart';
import 'package:terminal/components/account/account_hero_banner.dart';
import 'package:terminal/components/account/account_status_badge.dart';
import 'package:terminal/components/account/merchant_info_card.dart';
import 'package:terminal/components/account/store_info_card.dart';
import 'package:terminal/components/account/subscription_info_card.dart';
import 'package:terminal/components/account/terminal_info_card.dart';
import 'package:terminal/pages/account_page.dart';
import 'package:terminal/signals/account_signal.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) => MaterialApp(
  theme: TerminalTheme.light().toApproximateMaterialTheme(),
  home: FTheme(
    data: TerminalTheme.light(),
    child: FToaster(
      child: Material(type: MaterialType.transparency, child: child),
    ),
  ),
);

void main() {
  final now = DateTime(2026, 8, 23);

  final testTerminal = Terminal(
    code: 'TERM98765432',
    merchantId: 'm-1',
    name: 'Main Counter POS',
    storeId: 'store-100',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final testStore = Store(
    id: 'store-100',
    merchantId: 'm-1',
    name: 'Downtown Coffee & Cafe',
    storeType: 'cafe',
    isActive: true,
    isOnlineEnabled: true,
    slug: 'downtown-cafe',
    createdAt: now,
    updatedAt: now,
  );

  final testMerchant = Merchant(
    id: 'm-1',
    name: 'Jane Doe',
    businessName: 'Downtown Enterprises Ltd',
    whatsappNumber: '+91 98765 43210',
    email: 'jane@downtown.com',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    authSignal.value = AsyncData(testTerminal);
    terminalAccountSignal.value = AsyncData(
      TerminalAccount(
        terminal: testTerminal,
        store: testStore,
        merchant: testMerchant,
      ),
    );
  });

  testWidgets(
    'AccountPage renders hero banner and all 4 info cards on desktop layout',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_wrapTestWidget(const AccountPage()));
      await tester.pumpAndSettle();

      expect(find.byType(AccountHeroBanner), findsOneWidget);
      expect(find.byType(TerminalInfoCard), findsOneWidget);
      expect(find.byType(StoreInfoCard), findsOneWidget);
      expect(find.byType(SubscriptionInfoCard), findsOneWidget);
      expect(find.byType(MerchantInfoCard), findsOneWidget);

      expect(find.text('Main Counter POS'), findsWidgets);
      expect(find.text('TERM98765432'), findsOneWidget);
      expect(find.text('Downtown Coffee & Cafe'), findsWidgets);
      expect(find.text('Downtown Enterprises Ltd'), findsWidgets);
      expect(find.text('jane@downtown.com'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
    },
  );

  testWidgets('AccountPage renders in single column on mobile layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(_wrapTestWidget(const AccountPage()));
    await tester.pumpAndSettle();

    expect(find.byType(AccountHeroBanner), findsOneWidget);
    expect(find.byType(TerminalInfoCard), findsOneWidget);
    expect(find.byType(StoreInfoCard), findsOneWidget);
    expect(find.byType(SubscriptionInfoCard), findsOneWidget);
    expect(find.byType(MerchantInfoCard), findsOneWidget);
    expect(find.text('Downtown Coffee & Cafe'), findsWidgets);
    expect(find.text('Downtown Enterprises Ltd'), findsWidgets);
  });

  testWidgets('TerminalInfoCard displays copy icon button', (tester) async {
    await tester.pumpWidget(
      _wrapTestWidget(TerminalInfoCard(terminal: testTerminal)),
    );
    await tester.pumpAndSettle();

    final copyIconFinder = find.byIcon(FLucideIcons.copy);
    expect(copyIconFinder, findsOneWidget);
  });

  testWidgets(
    'AccountPage renders exactly one AccountStatusBadge on hero banner',
    (tester) async {
      await tester.pumpWidget(_wrapTestWidget(const AccountPage()));
      await tester.pumpAndSettle();

      expect(find.byType(AccountStatusBadge), findsOneWidget);
    },
  );

  testWidgets('AccountHeroAvatar renders single initial letter', (
    tester,
  ) async {
    await tester.pumpWidget(_wrapTestWidget(const AccountPage()));
    await tester.pumpAndSettle();

    expect(find.byType(AccountHeroAvatar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AccountHeroAvatar),
        matching: find.text('M'),
      ),
      findsOneWidget,
    );
  });
}
