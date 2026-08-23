import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/bottle_return_signal.dart';

void main() {
  group('Terminal Bottle Return Signals & Cart Integration Tests', () {
    setUp(() {
      BottleReturnActions.resetCartRewardState();
      bottleReturnConfigSignal.value = null;
    });

    test('Initial bottle return state is clean and unassigned', () {
      expect(bottleReturnConfigSignal.value, isNull);
      expect(customerPhoneBottleBalanceSignal.value, equals(0));
      expect(appliedBottleCreditSignal.value, equals(0));
      expect(appliedPhysicalCouponSignal.value, isNull);
    });

    test('applyAvailableCredit toggles balance deduction correctly', () {
      customerPhoneBottleBalanceSignal.value = 30;
      expect(appliedBottleCreditSignal.value, equals(0));

      BottleReturnActions.applyAvailableCredit();
      expect(appliedBottleCreditSignal.value, equals(0));

      appliedBottleCreditSignal.value = 30;
      expect(appliedBottleCreditSignal.value, equals(30));

      BottleReturnActions.applyAvailableCredit();
      expect(appliedBottleCreditSignal.value, equals(0));
    });

    test('removePhysicalCoupon clears applied coupon object', () {
      final coupon = BottlePhysicalCoupon(
        id: 'c-1',
        code: 'BTL998877',
        merchantId: 'm-1',
        storeId: 's-1',
        amount: 20,
        createdAt: DateTime.now(),
      );

      appliedPhysicalCouponSignal.value = coupon;
      expect(appliedPhysicalCouponSignal.value?.code, equals('BTL998877'));

      BottleReturnActions.removePhysicalCoupon();
      expect(appliedPhysicalCouponSignal.value, isNull);
    });

    test('resetCartRewardState completely resets phone balance and deductions', () {
      customerPhoneBottleBalanceSignal.value = 50;
      appliedBottleCreditSignal.value = 20;
      appliedPhysicalCouponSignal.value = BottlePhysicalCoupon(
        id: 'c-2',
        code: 'BTL123456',
        merchantId: 'm-1',
        storeId: 's-1',
        amount: 10,
        createdAt: DateTime.now(),
      );

      BottleReturnActions.resetCartRewardState();

      expect(customerPhoneBottleBalanceSignal.value, equals(0));
      expect(appliedBottleCreditSignal.value, equals(0));
      expect(appliedPhysicalCouponSignal.value, isNull);
    });
  });
}
