import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:terminal/theme.dart';
import 'package:terminal/utils/responsive_extensions.dart';

void main() {
  Widget buildApp(Widget child, Size size) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        theme: TerminalTheme.light().toApproximateMaterialTheme(),
        home: FTheme(
          data: TerminalTheme.light(),
          child: child,
        ),
      ),
    );
  }

  testWidgets('ResponsiveContextX computes correct flags and grid columns', (tester) async {
    // 1. Mobile screen (width 400)
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            expect(context.screenWidth, 400);
            expect(context.isMobile, isTrue);
            expect(context.isTablet, isFalse);
            expect(context.isDesktop, isFalse);
            expect(context.productGridColumns, 2);
            return const SizedBox();
          },
        ),
        const Size(400, 800),
      ),
    );

    // 2. Tablet screen (width 900, 60% catalog layout)
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            expect(context.screenWidth, 900);
            expect(context.isMobile, isFalse);
            expect(context.isTablet, isTrue);
            expect(context.isDesktop, isFalse);
            expect(context.productGridColumns, 2);
            return const SizedBox();
          },
        ),
        const Size(900, 900),
      ),
    );

    // 3. Desktop screen (width 1200)
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            expect(context.screenWidth, 1200);
            expect(context.isMobile, isFalse);
            expect(context.isTablet, isFalse);
            expect(context.isDesktop, isTrue);
            expect(context.productGridColumns, 3);
            return const SizedBox();
          },
        ),
        const Size(1200, 900),
      ),
    );

    // 4. Ultra-wide Desktop screen (width 1600)
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (context) {
            expect(context.screenWidth, 1600);
            expect(context.isMobile, isFalse);
            expect(context.isTablet, isFalse);
            expect(context.isDesktop, isTrue);
            expect(context.productGridColumns, 4);
            return const SizedBox();
          },
        ),
        const Size(1600, 1000),
      ),
    );
  });
}
