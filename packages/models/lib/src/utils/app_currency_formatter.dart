/// Standard Indian Rupee currency formatting utility across apps.
abstract final class AppCurrencyFormatter {
  /// Formats an amount in paise to a readable rupee string: `₹X.XX`.
  static String formatPaise(int paise) => '₹${(paise / 100.0).toStringAsFixed(2)}';

  /// Formats an amount in rupees: `₹X.XX`.
  static String formatRupees(num rupees) => '₹${rupees.toStringAsFixed(2)}';
}
