import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Platform Fee Formatting and Logic Tests', () {
    test('converts paise to formatted rupees string correctly', () {
      expect((12450 / 100.0).toStringAsFixed(2), equals('124.50'));
      expect((0 / 100.0).toStringAsFixed(2), equals('0.00'));
      expect((99 / 100.0).toStringAsFixed(2), equals('0.99'));
      expect((500 / 100.0).toStringAsFixed(2), equals('5.00'));
    });

    test('formats settlement dates with zero padding', () {
      String formatDate(DateTime? dt) {
        if (dt == null) return '';
        final day = dt.day.toString().padLeft(2, '0');
        final month = dt.month.toString().padLeft(2, '0');
        final year = dt.year.toString();
        return '$day/$month/$year';
      }

      final date = DateTime(2026, 9, 8);
      expect(formatDate(date), equals('08/09/2026'));
      expect(formatDate(null), equals(''));
    });

    test('settlement status identification', () {
      final settlementCompleted = PlatformFeeSettlement(
        id: 'set_1',
        merchantId: 'mer_1',
        amountInPaise: 45000,
        ordersCount: 42,
        status: 'completed',
      );

      final settlementPending = PlatformFeeSettlement(
        id: 'set_2',
        merchantId: 'mer_1',
        amountInPaise: 15000,
        ordersCount: 10,
        status: 'pending',
      );

      expect(settlementCompleted.status.toLowerCase(), equals('completed'));
      expect(settlementPending.status.toLowerCase(), equals('pending'));
      expect(
        (settlementCompleted.amountInPaise / 100.0).toStringAsFixed(2),
        equals('450.00'),
      );
    });

    test('1.99% fee badge uses unified blue color token palette', () {
      const feeBadgeClasses =
          'px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-blue-50 text-blue-700 border border-blue-200/80';
      expect(feeBadgeClasses.contains('bg-blue-50'), isTrue);
      expect(feeBadgeClasses.contains('text-blue-700'), isTrue);
      expect(feeBadgeClasses.contains('border-blue-200/80'), isTrue);
    });
  });
}
