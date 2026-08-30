import 'package:date_format/date_format.dart' as df;

/// Date formatting and preset range utilities for date pickers.
class DateRangeUtils {
  const DateRangeUtils._();

  static String cleanDate(String? str) {
    if (str == null || str.isEmpty) return '';
    final dateOnly = str.contains('T')
        ? str.split('T').first
        : str.split(' ').first;
    return dateOnly.trim();
  }

  static String formatDateForDisplay(String? dateStr) {
    final cleaned = cleanDate(dateStr);
    if (cleaned.isEmpty) return '';
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

  static String getLast7DaysString() => df.formatDate(
    DateTime.now().toLocal().subtract(const Duration(days: 6)),
    [df.yyyy, '-', df.mm, '-', df.dd],
  );

  static String getStartOfMonthString() {
    final now = DateTime.now().toLocal();
    return df.formatDate(
      DateTime(now.year, now.month, 1),
      [df.yyyy, '-', df.mm, '-', df.dd],
    );
  }

  static String getEndOfMonthString() {
    final now = DateTime.now().toLocal();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return df.formatDate(lastDay, [df.yyyy, '-', df.mm, '-', df.dd]);
  }

  static String computeButtonLabel({
    required String? fromDate,
    required String? toDate,
  }) {
    final from = cleanDate(fromDate);
    final to = cleanDate(toDate);
    final today = getTodayString();
    final monthStart = getStartOfMonthString();
    final monthEnd = getEndOfMonthString();

    if (from.isEmpty && to.isEmpty) {
      return 'All Time';
    }
    if (from == today && to == today) {
      return 'Today (${formatDateForDisplay(today)})';
    }
    if (from == monthStart && to == monthEnd) {
      return 'This Month (${formatDateForDisplay(monthStart)} - ${formatDateForDisplay(monthEnd)})';
    }
    if (from.isNotEmpty && to.isNotEmpty) {
      if (from == to) {
        return formatDateForDisplay(from);
      }
      return '${formatDateForDisplay(from)} - ${formatDateForDisplay(to)}';
    }
    if (from.isNotEmpty) {
      return 'From ${formatDateForDisplay(from)}';
    }
    return 'To ${formatDateForDisplay(to)}';
  }
}
