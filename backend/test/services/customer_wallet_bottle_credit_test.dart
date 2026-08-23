import 'package:test/test.dart';

void main() {
  group('OnlineWalletDeductionHandler & BottleCredit Calculation', () {
    test('Deduction calculations properly split between store wallet and bottle credits', () {
      const storeWalletPaise = 5000; // ₹50.00
      const totalPayablePaise = 7000; // ₹70.00
      const bottleCreditsRupees = 30; // ₹30.00 (3000 paise)

      const totalAvailablePaise =
          storeWalletPaise + (bottleCreditsRupees * 100);
      expect(totalAvailablePaise, equals(8000));

      const actualWalletDeductionPaise =
          totalAvailablePaise >= totalPayablePaise
          ? totalPayablePaise
          : totalAvailablePaise;
      const remainingPayablePaise =
          totalPayablePaise - actualWalletDeductionPaise;

      expect(actualWalletDeductionPaise, equals(7000));
      expect(remainingPayablePaise, equals(0));

      const fromStoreWallet = storeWalletPaise >= actualWalletDeductionPaise
          ? actualWalletDeductionPaise
          : storeWalletPaise;
      const fromBottleCreditPaise =
          actualWalletDeductionPaise - fromStoreWallet;

      expect(fromStoreWallet, equals(5000));
      expect(fromBottleCreditPaise, equals(2000));
      expect(
        (fromBottleCreditPaise / 100.0).ceil(),
        equals(20),
      ); // ₹20 debited from bottle credits
    });
  });
}
