import 'package:models/models.dart';

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
    return AppDateFormatter.formatDate(dt);
  }

  static String getTodayString() =>
      AppDateFormatter.formatDateIso(DateTime.now());

  static String getYesterdayString() => AppDateFormatter.formatDateIso(
        DateTime.now().subtract(const Duration(days: 1)),
      );

  static String getLast7DaysString() => AppDateFormatter.formatDateIso(
        DateTime.now().subtract(const Duration(days: 6)),
      );

  static String getStartOfMonthString() {
    final now = DateTime.now().toLocal();
    return AppDateFormatter.formatDateIso(
      DateTime(now.year, now.month, 1),
    );
  }

  static String getEndOfMonthString() {
    final now = DateTime.now().toLocal();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return AppDateFormatter.formatDateIso(lastDay);
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
