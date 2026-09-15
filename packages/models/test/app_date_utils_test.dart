import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('AppDateFormatter tests', () {
    test('formats null as empty string', () {
      expect(AppDateFormatter.formatDate(null), equals(''));
      expect(AppDateFormatter.formatDateTime(null), equals(''));
      expect(AppDateFormatter.formatTime(null), equals(''));
      expect(AppDateFormatter.formatDateIso(null), equals(''));
      expect(AppDateFormatter.formatDateRange(null, null), equals(''));
    });

    test('formats local date properly', () {
      final dt = DateTime(2026, 9, 15, 14, 30);
      expect(AppDateFormatter.formatDate(dt), equals('15/09/2026'));
      expect(AppDateFormatter.formatDateIso(dt), equals('2026-09-15'));
      expect(AppDateFormatter.formatTime(dt), equals('02:30 PM'));
      expect(
        AppDateFormatter.formatDateTime(dt),
        equals('15/09/2026 02:30 PM'),
      );
    });

    test('formats date range properly', () {
      final start = DateTime(2026, 9, 1);
      final end = DateTime(2026, 9, 15);
      expect(
        AppDateFormatter.formatDateRange(start, end),
        equals('01/09/2026 - 15/09/2026'),
      );
      expect(
        AppDateFormatter.formatDateRange(start, null),
        equals('01/09/2026'),
      );
      expect(
        AppDateFormatter.formatDateRange(null, end),
        equals('15/09/2026'),
      );
    });
  });

  group('AppDateQueryHelper tests', () {
    test('localDayBoundsUtc computes 00:00 to 23:59:59.999 in UTC', () {
      final local = DateTime(2026, 9, 15);
      final (startUtc, endUtc) = AppDateQueryHelper.localDayBoundsUtc(local);
      expect(startUtc.isUtc, isTrue);
      expect(endUtc.isUtc, isTrue);
      expect(
        endUtc.difference(startUtc).inMilliseconds,
        equals(86399999),
      );
    });

    test('localDateRangeStringsToUtcIso converts date strings correctly', () {
      final (fromIso, toIso) =
          AppDateQueryHelper.localDateRangeStringsToUtcIso(
        fromDate: '2026-09-15',
        toDate: '2026-09-15',
      );
      expect(fromIso, isNotNull);
      expect(toIso, isNotNull);
      expect(fromIso!.endsWith('Z'), isTrue);
      expect(toIso!.endsWith('Z'), isTrue);
      final fromDt = DateTime.parse(fromIso);
      final toDt = DateTime.parse(toIso);
      expect(toDt.isAfter(fromDt), isTrue);
      expect(toDt.difference(fromDt).inMilliseconds, equals(86399999));
    });

    test('parseQueryFromDate handles ISO timestamps and date-only', () {
      expect(AppDateQueryHelper.parseQueryFromDate(null), isNull);
      expect(AppDateQueryHelper.parseQueryFromDate(''), isNull);

      final isoResult = AppDateQueryHelper.parseQueryFromDate(
        '2026-09-14T18:30:00.000Z',
      );
      expect(isoResult, equals(DateTime.utc(2026, 9, 14, 18, 30)));

      final dateOnlyResult =
          AppDateQueryHelper.parseQueryFromDate('2026-09-15');
      expect(dateOnlyResult, equals(DateTime.utc(2026, 9, 15, 0, 0, 0)));
    });

    test('parseQueryToDate preserves explicit time when T is present', () {
      expect(AppDateQueryHelper.parseQueryToDate(null), isNull);
      expect(AppDateQueryHelper.parseQueryToDate(''), isNull);

      final isoResult = AppDateQueryHelper.parseQueryToDate(
        '2026-09-15T18:29:59.999Z',
      );
      expect(
        isoResult,
        equals(DateTime.utc(2026, 9, 15, 18, 29, 59, 999)),
      );

      final dateOnlyResult =
          AppDateQueryHelper.parseQueryToDate('2026-09-15');
      expect(
        dateOnlyResult,
        equals(DateTime.utc(2026, 9, 15, 23, 59, 59, 999)),
      );
    });
  });
}
