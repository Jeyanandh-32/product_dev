import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/router_signal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Terminal Router Tests', () {
    final now = DateTime.now();
    final dummyTerminal = Terminal(
      code: 'TRM-1',
      merchantId: 'm1',
      storeId: 's1',
      name: 'Counter 1',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    tearDown(() {
      authSignal.value = const AsyncData(null);
    });

    test('usePathUrlStrategy executes cleanly without exceptions', () {
      expect(usePathUrlStrategy, returnsNormally);
    });

    test('appRouter configuration contains all required routes', () {
      final routePaths = appRouter.configuration.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();

      expect(routePaths, containsAll(['/loading', '/login', '/', '/cart']));
    });

    test('RouterListenable notifies listeners when authSignal changes', () {
      final listenable = RouterListenable();
      var notificationCount = 0;
      listenable.addListener(() {
        notificationCount++;
      });

      authSignal.value = AsyncData(dummyTerminal);
      expect(notificationCount, greaterThan(0));
    });

    testWidgets('appRouter redirects unauthenticated users to /login', (tester) async {
      authSignal.value = const AsyncData(null);
      await tester.pumpWidget(
        WidgetsApp.router(
          color: const Color(0xFF000000),
          routerConfig: appRouter,
        ),
      );
      await tester.pumpAndSettle();

      expect(appRouter.routeInformationProvider.value.uri.path, '/login');
    });

    testWidgets('appRouter keeps authenticated users on target route', (tester) async {
      authSignal.value = AsyncData(dummyTerminal);
      appRouter.go('/cart');
      await tester.pumpWidget(
        WidgetsApp.router(
          color: const Color(0xFF000000),
          routerConfig: appRouter,
        ),
      );
      await tester.pumpAndSettle();

      expect(appRouter.routeInformationProvider.value.uri.path, '/cart');
    });
  });
}
