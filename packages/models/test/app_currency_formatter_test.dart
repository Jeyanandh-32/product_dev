import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('AppCurrencyFormatter', () {
    test('formatPaise formats paise into rupees with 2 decimal places', () {
      expect(AppCurrencyFormatter.formatPaise(10000), equals('₹100.00'));
      expect(AppCurrencyFormatter.formatPaise(12345), equals('₹123.45'));
      expect(AppCurrencyFormatter.formatPaise(0), equals('₹0.00'));
      expect(AppCurrencyFormatter.formatPaise(50), equals('₹0.50'));
    });

    test('formatRupees formats rupees with 2 decimal places', () {
      expect(AppCurrencyFormatter.formatRupees(100), equals('₹100.00'));
      expect(AppCurrencyFormatter.formatRupees(99.5), equals('₹99.50'));
      expect(AppCurrencyFormatter.formatRupees(0), equals('₹0.00'));
    });
  });
}
