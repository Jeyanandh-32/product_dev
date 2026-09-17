import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_dropdown_filter.dart';
import 'package:terminal/components/orders/orders_date_filter_row.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return FTheme(
    data: TerminalTheme.light(false),
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets(
    'OrdersDateFilterRow renders in horizontal Wrap with compact pills and dropdowns',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrapTestWidget(const OrdersDateFilterRow()));
      await tester.pumpAndSettle();

      final wrapFinder = find.byType(Wrap);
      expect(wrapFinder, findsOneWidget);

      final wrapWidget = tester.widget<Wrap>(wrapFinder);
      expect(wrapWidget.direction, Axis.horizontal);
      expect(wrapWidget.spacing, 8);
      expect(wrapWidget.runSpacing, 8);

      final paymentFinder = find.byType(OrderDropdownFilter<PaymentMethod>);
      final statusFinder = find.byType(OrderDropdownFilter<OrderStatus>);
      expect(paymentFinder, findsOneWidget);
      expect(statusFinder, findsOneWidget);

      final paymentSize = tester.getSize(paymentFinder);
      expect(paymentSize.width, lessThan(220));

      final statusSize = tester.getSize(statusFinder);
      expect(statusSize.width, lessThan(220));
    },
  );
}
