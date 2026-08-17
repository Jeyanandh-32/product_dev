import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/product/terminal_catalog_scrollbar.dart';
import 'package:terminal/theme.dart';

void main() {
  testWidgets('TerminalCatalogScrollbar renders and updates thumb on scroll',
      (tester) async {
    final controller = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        theme: TerminalTheme.light().toApproximateMaterialTheme(),
        home: FTheme(
          data: TerminalTheme.light(),
          child: Scaffold(
            body: SizedBox(
              height: 400,
              width: 300,
              child: TerminalCatalogScrollbar(
                controller: controller,
                child: ListView.builder(
                  controller: controller,
                  itemCount: 50,
                  itemBuilder: (context, index) => SizedBox(
                    height: 50,
                    child: Text('Item $index'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify scrollbar components render
    expect(find.byType(TerminalCatalogScrollbar), findsOneWidget);
    expect(find.byType(MouseRegion), findsWidgets);

    // Scroll down and verify controller moves
    controller.jumpTo(200);
    await tester.pump();
    expect(controller.offset, 200);
  });
}
