import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/navigation/terminal_app_bar.dart';
import 'package:terminal/components/navigation/terminal_bottle_returns_button.dart';
import 'package:terminal/components/navigation/terminal_logout_button.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return MaterialApp(
    theme: TerminalTheme.light().toApproximateMaterialTheme(),
    home: FTheme(
      data: TerminalTheme.light(),
      child: Material(type: MaterialType.transparency, child: child),
    ),
  );
}

void main() {
  final now = DateTime.now();

  setUp(() {
    initDio(Dio(BaseOptions(baseUrl: 'http://localhost:8080')));
    activeTerminalPageSignal.value = TerminalNavPage.billing;
    authSignal.value = AsyncData(
      Terminal(
        code: 'TERM001',
        merchantId: 'm-1',
        name: 'Main Counter',
        storeId: 'store-1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  testWidgets(
    'TerminalAppBar renders Returns button without overflow on mobile 360px',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bottleReturnConfigSignal.value = BottleReturnConfig(
        storeId: 'store-1',
        isEnabled: true,
        rewardAmountInRupees: 10,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        _wrapTestWidget(
          const FScaffold(header: TerminalAppBar(), child: SizedBox.shrink()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TerminalBottleReturnsButton), findsOneWidget);
      expect(find.byIcon(FLucideIcons.recycle), findsOneWidget);
      expect(find.text('Billing'), findsOneWidget);
      expect(find.byType(TerminalLogoutButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
