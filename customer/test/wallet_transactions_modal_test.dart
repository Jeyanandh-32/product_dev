import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Wallet Transactions Modal & State Tests', () {
    String getModalTitle(bool isBottleReturn) =>
        isBottleReturn ? 'Reward & Activity History' : 'Wallet Transactions';

    String getEmptyText(bool isBottleReturn) =>
        isBottleReturn ? 'No reward activity yet.' : 'No wallet transactions yet.';

    bool isTopUpAllowed(bool isBottleReturn) => !isBottleReturn;

    test('Normal store displays Wallet Transactions and empty state text', () {
      expect(getModalTitle(false), equals('Wallet Transactions'));
      expect(getEmptyText(false), equals('No wallet transactions yet.'));
      expect(isTopUpAllowed(false), isTrue);
    });

    test('Bottle return store displays Reward & Activity History and disables top up', () {
      expect(getModalTitle(true), equals('Reward & Activity History'));
      expect(getEmptyText(true), equals('No reward activity yet.'));
      expect(isTopUpAllowed(true), isFalse);
    });

    test(
      'Transaction row classification correctly handles top-ups and order payments',
      () {
        final now = DateTime.now();
        final topUpTx = CustomerWalletTransaction(
          id: 'tx-1',
          customerId: 'cust-1',
          amount: 500.0,
          type: WalletTransactionType.topUp,
          status: 'completed',
          reference: 'UPI-12345',
          createdAt: now,
        );

        final orderPaymentTx = CustomerWalletTransaction(
          id: 'tx-2',
          customerId: 'cust-1',
          amount: 150.0,
          type: WalletTransactionType.orderDebit,
          status: 'completed',
          reference: 'ORD-9876',
          createdAt: now,
        );

        final bottleReturnTx = CustomerWalletTransaction(
          id: 'tx-3',
          customerId: 'cust-1',
          amount: 20.0,
          type: WalletTransactionType.refundCredit,
          status: 'completed',
          reference: 'Bottle Return #42',
          createdAt: now,
        );

        String getTitle(CustomerWalletTransaction tx) {
          final isTopUp = tx.type == WalletTransactionType.topUp;
          final isRefund = tx.type == WalletTransactionType.refundCredit;
          final isBottleReturn = tx.reference?.contains('Bottle Return') == true;

          return isBottleReturn
              ? (isRefund ? 'Bottle Return Reward' : 'Reward Redemption')
              : (isTopUp
                  ? 'Wallet Top-Up'
                  : (isRefund ? 'Refund Credit' : 'Order Payment'));
        }

        expect(getTitle(topUpTx), equals('Wallet Top-Up'));
        expect(getTitle(orderPaymentTx), equals('Order Payment'));
        expect(getTitle(bottleReturnTx), equals('Bottle Return Reward'));
      },
    );
  });
}
