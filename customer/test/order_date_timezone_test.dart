import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Customer Order & Transaction Date Timezone Tests', () {
    // 20:30 UTC on Sep 14 corresponds to 02:00 AM on Sep 15 in IST (+05:30).
    final utcCreatedAt = DateTime.parse('2026-09-14T20:30:00.000Z');

    test('Order createdAt converted to local gives correct local day', () {
      final order = Order(
        id: 'ord-cust-1',
        merchantId: 'm-1',
        storeId: 'store-1',
        orderReference: 'ORD-CUST-001',
        billNo: 55,
        source: OrderSource.web,
        type: OrderType.takeaway,
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.completed,
        paymentMethod: PaymentMethod.upi,
        subtotal: 100.0,
        taxTotal: 5.0,
        grandTotal: 105.0,
        items: [],
        createdAt: utcCreatedAt,
        updatedAt: utcCreatedAt,
      );

      final localCreatedAt = order.createdAt.toLocal();
      final formattedDate = AppDateFormatter.formatDate(localCreatedAt);

      final expectedDate =
          '${localCreatedAt.day.toString().padLeft(2, '0')}/${localCreatedAt.month.toString().padLeft(2, '0')}/${localCreatedAt.year}';
      expect(formattedDate, equals(expectedDate));
    });

    test('Wallet transaction date converted to local preserves local calendar day', () {
      final tx = CustomerWalletTransaction(
        id: 'tx-tz-1',
        customerId: 'cust-1',
        amount: 250.0,
        type: WalletTransactionType.topUp,
        status: 'completed',
        reference: 'UPI-TZ-99',
        createdAt: utcCreatedAt,
      );

      final localDt = tx.createdAt.toLocal();
      final formatted = AppDateFormatter.formatDate(localDt);
      final expectedDate =
          '${localDt.day.toString().padLeft(2, '0')}/${localDt.month.toString().padLeft(2, '0')}/${localDt.year}';

      expect(formatted, equals(expectedDate));
    });
  });
}
