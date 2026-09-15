import 'package:date_format/date_format.dart' as df;

/// Standardized date and time formatting utilities across the application suite.
///
/// Ensures all visual date displays automatically convert to local timezone
/// and adhere to consistent formatting tokens.
class AppDateFormatter {
  const AppDateFormatter._();

  /// Standard date format tokens: DD/MM/YYYY
  static const List<String> dateTokens = [df.dd, '/', df.mm, '/', df.yyyy];

  /// Standard date and time format tokens: DD/MM/YYYY hh:mm a
  static const List<String> dateTimeTokens = [
    df.dd,
    '/',
    df.mm,
    '/',
    df.yyyy,
    ' ',
    df.hh,
    ':',
    df.nn,
    ' ',
    df.am,
  ];

  /// Standard 12-hour time format tokens: hh:mm a
  static const List<String> timeTokens = [df.hh, ':', df.nn, ' ', df.am];

  /// Standard ISO date tokens: YYYY-MM-DD
  static const List<String> isoDateTokens = [
    df.yyyy,
    '-',
    df.mm,
    '-',
    df.dd,
  ];

  /// Formats a [DateTime] into a localized date string: `DD/MM/YYYY`.
  /// Returns an empty string if [dateTime] is null.
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return df.formatDate(dateTime.toLocal(), dateTokens);
  }

  /// Formats a [DateTime] into a localized date and time string: `DD/MM/YYYY hh:mm a`.
  /// Returns an empty string if [dateTime] is null.
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return df.formatDate(dateTime.toLocal(), dateTimeTokens);
  }

  /// Formats a [DateTime] into a localized 12-hour time string: `hh:mm a`.
  /// Returns an empty string if [dateTime] is null.
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return df.formatDate(dateTime.toLocal(), timeTokens);
  }

  /// Formats a [DateTime] into a localized ISO date string: `YYYY-MM-DD`.
  /// Returns an empty string if [dateTime] is null.
  static String formatDateIso(DateTime? dateTime) {
    if (dateTime == null) return '';
    return df.formatDate(dateTime.toLocal(), isoDateTokens);
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
