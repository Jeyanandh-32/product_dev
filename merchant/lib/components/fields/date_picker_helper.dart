import 'package:models/models.dart';

/// Date formatting and string cleaning helper utilities for date pickers.
class DatePickerHelper {
  const DatePickerHelper._();

  static String cleanDate(String? str) {
    if (str == null || str.isEmpty) return getTodayString();
    final dateOnly = str.contains('T')
        ? str.split('T').first
        : str.split(' ').first;
    return dateOnly.trim();
  }

  static String formatDateForDisplay(String? dateStr) {
    final cleaned = cleanDate(dateStr);
    final dt = DateTime.tryParse(cleaned);
    if (dt == null) return cleaned;
    return AppDateFormatter.formatDate(dt);
  }

  static String getTodayString() =>
      AppDateFormatter.formatDateIso(DateTime.now());

  static String getYesterdayString() => AppDateFormatter.formatDateIso(
        DateTime.now().subtract(const Duration(days: 1)),
      );
}
