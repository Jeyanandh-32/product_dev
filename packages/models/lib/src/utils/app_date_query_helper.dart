/// Utilities for constructing and parsing timezone-safe date query boundaries.
///
/// Ensures client applications compute local start/end of day and send ISO-8601
/// UTC strings, while the backend correctly interprets both full ISO timestamps
/// and date-only fallbacks without stripping time.
class AppDateQueryHelper {
  const AppDateQueryHelper._();

  /// Computes start and end of day in UTC for a given local date.
  static (DateTime startUtc, DateTime endUtc) localDayBoundsUtc(
    DateTime localDate,
  ) {
    final startLocal = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );
    final endLocal = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
      23,
      59,
      59,
      999,
    );
    return (startLocal.toUtc(), endLocal.toUtc());
  }

  /// Computes start and end of day in UTC ISO-8601 strings for a given local date.
  static (String fromIsoUtc, String toIsoUtc) localDayBoundsIso(
    DateTime localDate,
  ) {
    final (startUtc, endUtc) = localDayBoundsUtc(localDate);
    return (startUtc.toIso8601String(), endUtc.toIso8601String());
  }

  /// Computes start and end bounds in UTC for a given local date range.
  static (DateTime startUtc, DateTime endUtc) localRangeBoundsUtc(
    DateTime localStart,
    DateTime localEnd,
  ) {
    final startLocal = DateTime(
      localStart.year,
      localStart.month,
      localStart.day,
    );
    final endLocal = DateTime(
      localEnd.year,
      localEnd.month,
      localEnd.day,
      23,
      59,
      59,
      999,
    );
    return (startLocal.toUtc(), endLocal.toUtc());
  }

  /// Computes start and end bounds in UTC ISO-8601 strings for a given local date range.
  static (String fromIsoUtc, String toIsoUtc) localRangeBoundsIso(
    DateTime localStart,
    DateTime localEnd,
  ) {
    final (startUtc, endUtc) = localRangeBoundsUtc(localStart, localEnd);
    return (startUtc.toIso8601String(), endUtc.toIso8601String());
  }

  /// Converts optional local date strings (e.g. `YYYY-MM-DD` or ISO) into UTC ISO query parameters.
  static (String? fromIsoUtc, String? toIsoUtc) localDateRangeStringsToUtcIso({
    String? fromDate,
    String? toDate,
  }) {
    String? fromResult;
    String? toResult;

    if (fromDate != null && fromDate.trim().isNotEmpty) {
      final cleanFrom = fromDate.trim();
      if (cleanFrom.contains('T')) {
        final parsed = DateTime.tryParse(cleanFrom);
        fromResult = parsed?.toUtc().toIso8601String() ?? cleanFrom;
      } else {
        final parsed = DateTime.tryParse(cleanFrom);
        if (parsed != null) {
          final startLocal = DateTime(parsed.year, parsed.month, parsed.day);
          fromResult = startLocal.toUtc().toIso8601String();
        }
      }
    }

    if (toDate != null && toDate.trim().isNotEmpty) {
      final cleanTo = toDate.trim();
      if (cleanTo.contains('T')) {
        final parsed = DateTime.tryParse(cleanTo);
        toResult = parsed?.toUtc().toIso8601String() ?? cleanTo;
      } else {
        final parsed = DateTime.tryParse(cleanTo);
        if (parsed != null) {
          final endLocal = DateTime(
            parsed.year,
            parsed.month,
            parsed.day,
            23,
            59,
            59,
            999,
          );
          toResult = endLocal.toUtc().toIso8601String();
        }
      }
    }

    return (fromResult, toResult);
  }

  /// Parses a backend `fromDate` query parameter into a UTC [DateTime].
  /// Preserves explicit UTC time if ISO string has `'T'`, otherwise treats as date start.
  static DateTime? parseQueryFromDate(String? fromDateStr) {
    if (fromDateStr == null || fromDateStr.trim().isEmpty) return null;
    final clean = fromDateStr.trim();
    final parsed = DateTime.tryParse(clean);
    if (parsed == null) return null;
    if (clean.contains('T')) {
      return parsed.toUtc();
    }
    return DateTime.utc(parsed.year, parsed.month, parsed.day);
  }

  /// Parses a backend `toDate` query parameter into a UTC [DateTime].
  /// Preserves explicit UTC time if ISO string has `'T'`, otherwise falls back to UTC 23:59:59.999.
  static DateTime? parseQueryToDate(String? toDateStr) {
    if (toDateStr == null || toDateStr.trim().isEmpty) return null;
    final clean = toDateStr.trim();
    final parsed = DateTime.tryParse(clean);
    if (parsed == null) return null;
    if (clean.contains('T')) {
      return parsed.toUtc();
    }
    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      23,
      59,
      59,
      999,
    );
  }
}
