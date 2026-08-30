import 'package:date_format/date_format.dart' as df;

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
    return df.formatDate(dt.toLocal(), [df.dd, '/', df.mm, '/', df.yyyy]);
  }

  static String getTodayString() => df.formatDate(DateTime.now().toLocal(), [
    df.yyyy,
    '-',
    df.mm,
    '-',
    df.dd,
  ]);

  static String getYesterdayString() => df.formatDate(
    DateTime.now().toLocal().subtract(const Duration(days: 1)),
    [df.yyyy, '-', df.mm, '-', df.dd],
  );
}
