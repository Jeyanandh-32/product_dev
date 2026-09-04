import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:models/models.dart';
import 'package:terminal/components/orders/order_breakdown_popover.dart';
import 'package:terminal/components/orders/order_details_totals.dart';
import 'package:terminal/theme.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: TerminalTheme.light().toApproximateMaterialTheme(),
  home: FTheme(
    data: TerminalTheme.light(),
    child: Material(child: Center(child: child)),
  ),
);

void main() {
  final now = DateTime.now();
  final testOrder = Order(
    id: 'ord-1',
    merchantId: 'm-1',
    storeId: 'store-1',
    orderReference: 'ORD-9901',
    billNo: 1042,
    source: OrderSource.terminal,
    type: OrderType.takeaway,
    status: OrderStatus.completed,
    paymentStatus: PaymentStatus.completed,
    paymentMethod: PaymentMethod.cash,
    subtotal: 200.0,
    taxTotal: 10.0,
    grandTotal: 210.0,
    terminalCode: 'TERM001',
    items: [],
    createdAt: now,
    updatedAt: now,
  );

  testWidgets(
    'OrderDetailsTotals keeps previous details inline with Details button',
    (tester) async {
      await tester.pumpWidget(_wrap(OrderDetailsTotals(order: testOrder)));
      await tester.pumpAndSettle();

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('₹200.00'), findsOneWidget);
      expect(find.text('Taxes'), findsOneWidget);
      expect(find.text('₹10.00'), findsOneWidget);
      expect(find.text('Grand Total'), findsOneWidget);
      expect(find.text('₹210.00'), findsOneWidget);
      expect(find.byType(OrderBreakdownPopover), findsNothing);
    },
  );

  testWidgets(
    'Tapping Details opens popover with additional details and close dismisses it',
    (tester) async {
      await tester.pumpWidget(_wrap(OrderDetailsTotals(order: testOrder)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();

      expect(find.byType(OrderBreakdownPopover), findsOneWidget);
      expect(find.text('Additional Details'), findsOneWidget);
      expect(find.text('Total No of Items'), findsOneWidget);
      expect(find.text('Total Order Quantity'), findsOneWidget);

      await tester.tap(find.byIcon(FLucideIcons.x));
      await tester.pumpAndSettle();

      expect(find.byType(OrderBreakdownPopover), findsNothing);
    },
  );

  testWidgets(
    'Order with wallet deduction displays wallet split inline in summary card',
    (tester) async {
      final walletOrder = testOrder.copyWith(
        walletDeduction: 50.0,
        grandTotal: 160.0,
      );

      await tester.pumpWidget(_wrap(OrderDetailsTotals(order: walletOrder)));
      await tester.pumpAndSettle();

      expect(find.text('Order Total'), findsOneWidget);
      expect(find.text('Wallet Paid'), findsOneWidget);
      expect(find.text('₹50.00'), findsOneWidget);
      expect(find.text('CASH Paid'), findsOneWidget);
      expect(find.text('₹160.00'), findsOneWidget);
      expect(find.text('Total Paid'), findsOneWidget);
      expect(find.text('₹210.00'), findsNWidgets(2));
    },
  );
}
