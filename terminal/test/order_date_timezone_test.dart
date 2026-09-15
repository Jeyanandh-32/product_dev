import 'package:date_format/date_format.dart' as df;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_card_footer.dart';
import 'package:terminal/components/orders/order_details_header.dart';
import 'package:terminal/theme.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: TerminalTheme.light().toApproximateMaterialTheme(),
  home: FTheme(
    data: TerminalTheme.light(),
    child: Material(child: Center(child: child)),
  ),
);

void main() {
  group('Order Date Timezone Tests', () {
    // 20:30 UTC on Sep 14 is 02:00 AM on Sep 15 in IST (+05:30).
    final utcCreatedAt = DateTime.parse('2026-09-14T20:30:00.000Z');

    final testOrder = Order(
      id: 'ord-tz-1',
      merchantId: 'm-1',
      storeId: 'store-1',
      orderReference: 'ORD-TZ-001',
      billNo: 101,
      source: OrderSource.terminal,
      type: OrderType.takeaway,
      status: OrderStatus.completed,
      paymentStatus: PaymentStatus.completed,
      paymentMethod: PaymentMethod.cash,
      subtotal: 100.0,
      taxTotal: 5.0,
      grandTotal: 105.0,
      terminalCode: 'TERM01',
      items: [],
      createdAt: utcCreatedAt,
      updatedAt: utcCreatedAt,
    );

    testWidgets('OrderCardFooter renders date using local timezone', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(OrderCardFooter(order: testOrder)));
      await tester.pumpAndSettle();

      final local = utcCreatedAt.toLocal();
      final expectedDatePrefix =
          df.formatDate(local, [df.dd, '/', df.mm, '/', df.yyyy]);

      expect(find.textContaining(expectedDatePrefix), findsOneWidget);
    });

    testWidgets('OrderDetailsHeader renders date using local timezone', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(OrderDetailsHeader(order: testOrder, onClose: () {})),
      );
      await tester.pumpAndSettle();

      final local = utcCreatedAt.toLocal();
      final expectedDatePrefix =
          df.formatDate(local, [df.dd, '/', df.mm, '/', df.yyyy]);

      expect(find.textContaining(expectedDatePrefix), findsOneWidget);
    });
  });
}
