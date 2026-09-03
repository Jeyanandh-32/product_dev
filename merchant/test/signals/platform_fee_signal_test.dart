import 'package:merchant/signals/platform_fee_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';
import 'package:test/test.dart';

void main() {
  group('Merchant Platform Fee Signal State Tests', () {
    setUp(() {
      resetPlatformFeeSignals();
    });

    test('resetPlatformFeeSignals clears all state', () {
      platformFeeSummarySignal.value = const AsyncData(
        MerchantPlatformFeeSummary(
          unsettledAmountInPaise: 5000,
          unsettledOrdersCount: 2,
        ),
      );
      isPayingPlatformFeeSignal.value = true;

      resetPlatformFeeSignals();

      expect(platformFeeSummarySignal.value.value, isNull);
      expect(isPayingPlatformFeeSignal.value, isFalse);
    });

    test('initial signal states are idle and empty', () {
      expect(platformFeeSummarySignal.value.value, isNull);
      expect(isPayingPlatformFeeSignal.value, isFalse);
    });
  });
}
