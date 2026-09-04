import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/returnable_products_modal.dart';
import 'package:terminal/components/inventory/modals/returnable_products_search_bar.dart';
import 'package:terminal/signals/bottle_return_product_signal.dart';
import 'package:terminal/theme.dart';

Widget _wrap(Widget child) => FTheme(
      data: TerminalTheme.light(false),
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );

void main() {
  setUp(() {
    bottleReturnProductsSignal.value = AsyncData([
      {
        'productId': 'p1',
        'name': 'Budweiser Pint',
        'categoryName': 'Beer',
        'sellingPrice': 180.0,
        'isReturnable': true,
        'imageUrl': null,
      },
    ]);
  });

  testWidgets('ReturnableProductsModal renders with 16px horizontal insetPadding and maxWidth 540', (tester) async {
    tester.view.physicalSize = const Size(380, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(const ReturnableProductsModal()));
    await tester.pumpAndSettle();

    final dialogFinder = find.byType(Dialog);
    expect(dialogFinder, findsOneWidget);

    final dialog = tester.widget<Dialog>(dialogFinder);
    expect(dialog.insetPadding, const EdgeInsets.symmetric(horizontal: 16, vertical: 24));

    final constrainedBoxFinder = find.descendant(
      of: dialogFinder,
      matching: find.byType(ConstrainedBox),
    );
    expect(constrainedBoxFinder, findsWidgets);

    final customBox = tester
        .widgetList<ConstrainedBox>(constrainedBoxFinder)
        .where((cb) => cb.constraints.maxWidth == 540);
    expect(customBox, isNotEmpty);

    expect(find.text('Returnable Bottle Products'), findsOneWidget);
    expect(find.byType(ReturnableProductsSearchBar), findsOneWidget);
    expect(find.text('Budweiser Pint'), findsOneWidget);
  });
}
