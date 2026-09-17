import 'package:intl/intl.dart';

/// Standardized date and time formatting utilities across the application suite.
///
/// Ensures all visual date displays automatically convert to local timezone
/// and adhere to consistent formatting tokens.
class AppDateFormatter {
  const AppDateFormatter._();

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy hh:mm a');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _isoDateFormat = DateFormat('yyyy-MM-dd');

  /// Formats a [DateTime] into a localized date string: `DD/MM/YYYY`.
  /// Returns an empty string if [dateTime] is null.
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return _dateFormat.format(dateTime.toLocal());
  }

  /// Formats a [DateTime] into a localized date and time string: `DD/MM/YYYY hh:mm a`.
  /// Returns an empty string if [dateTime] is null.
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return _dateTimeFormat.format(dateTime.toLocal());
  }

  /// Formats a [DateTime] into a localized 12-hour time string: `hh:mm a`.
  /// Returns an empty string if [dateTime] is null.
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return _timeFormat.format(dateTime.toLocal());
  }

  /// Formats a [DateTime] into a localized ISO date string: `YYYY-MM-DD`.
  /// Returns an empty string if [dateTime] is null.
  static String formatDateIso(DateTime? dateTime) {
    if (dateTime == null) return '';
    return _isoDateFormat.format(dateTime.toLocal());
  }

  /// Formats start and end dates into a readable range string: `DD/MM/YYYY - DD/MM/YYYY`.
  static String formatDateRange(DateTime? start, DateTime? end) {
    final startStr = formatDate(start);
    final endStr = formatDate(end);
    if (startStr.isEmpty && endStr.isEmpty) return '';
    if (startStr.isEmpty) return endStr;
    if (endStr.isEmpty) return startStr;
    return '$startStr - $endStr';
  }
}
