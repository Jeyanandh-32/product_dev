import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_actions.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_dialog.dart';
import 'package:terminal/theme.dart';

Widget _wrap(Widget child) => FTheme(
      data: TerminalTheme.light(false),
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );

void main() {
  testWidgets(
    'AcceptBottleReturnsDialog renders with 16px horizontal insetPadding, maxWidth 540, and SizedBox width infinity',
    (tester) async {
      tester.view.physicalSize = const Size(380, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(const AcceptBottleReturnsDialog()));
      await tester.pumpAndSettle();

      final dialogFinder = find.byType(Dialog);
      expect(dialogFinder, findsOneWidget);

      final dialog = tester.widget<Dialog>(dialogFinder);
      expect(
        dialog.insetPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      );

      final constrainedBoxFinder = find.descendant(
        of: dialogFinder,
        matching: find.byType(ConstrainedBox),
      );
      expect(constrainedBoxFinder, findsWidgets);

      final customBox = tester
          .widgetList<ConstrainedBox>(constrainedBoxFinder)
          .where((cb) => cb.constraints.maxWidth == 540);
      expect(customBox, isNotEmpty);

      final sizedBoxFinder = find.descendant(
        of: dialogFinder,
        matching: find.byType(SizedBox),
      );
      final fullWidthBox = tester
          .widgetList<SizedBox>(sizedBoxFinder)
          .where((sb) => sb.width == double.infinity);
      expect(fullWidthBox, isNotEmpty);

      expect(find.text('Accept Bottle Returns'), findsOneWidget);
      expect(find.byType(AcceptBottleReturnsActions), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Complete Return'), findsOneWidget);
    },
  );
}
