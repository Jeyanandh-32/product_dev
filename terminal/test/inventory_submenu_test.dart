import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/navigation/terminal_navigation_dropdown.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return MaterialApp(
    theme: TerminalTheme.light().toApproximateMaterialTheme(),
    home: FTheme(
      data: TerminalTheme.light(),
      child: FToaster(
        child: Material(type: MaterialType.transparency, child: child),
      ),
    ),
  );
}

void main() {
  setUp(() {
    activeTerminalPageSignal.value = TerminalNavPage.billing;
  });

  testWidgets('Desktop inventory submenu opens to the side on hover', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      _wrapTestWidget(
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TerminalNavigationDropdown(),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Billing'));
    await tester.pumpAndSettle();

    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Products'), findsNothing);

    // Mouse hover over Inventory trigger item
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(tester.getCenter(find.text('Inventory')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Counters'), findsOneWidget);

    final inventoryRect = tester.getRect(find.text('Inventory'));
    final productsRect = tester.getRect(find.text('Products'));

    // Verifies side flyout positioning (adjacent horizontally, NOT above or below)
    final isSideFlyout =
        productsRect.right <= inventoryRect.left ||
        productsRect.left >= inventoryRect.right;
    expect(isSideFlyout, isTrue);

    // Tapping submenu item navigates correctly
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();

    expect(activeTerminalPageSignal.value, TerminalNavPage.inventoryProducts);
    await gesture.removePointer();
  });

  testWidgets('Desktop inventory submenu opens on click and navigates', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      _wrapTestWidget(
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TerminalNavigationDropdown(),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Billing'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOneWidget);

    await tester.tap(find.text('Categories'));
    await tester.pumpAndSettle();

    expect(activeTerminalPageSignal.value, TerminalNavPage.inventoryCategories);
  });
}
