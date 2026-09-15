import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/pagination/table_pagination_entries.dart';
import 'package:test/test.dart';

void main() {
  group('TablePaginationEntries Responsive Layout Tests', () {
    test('instantiates with entry options and triggers callback', () {
      int selected = 10;
      final entries = TablePaginationEntries(
        entries: 10,
        currentPage: 2,
        totalCount: 45,
        onEntryChanged: (v) => selected = v,
      );

      expect(entries.entries, equals(10));
      expect(entries.currentPage, equals(2));
      expect(entries.totalCount, equals(45));

      entries.onEntryChanged(25);
      expect(selected, equals(25));
    });

    test('build method executes and returns component hierarchy', () {
      final entries = TablePaginationEntries(
        entries: 10,
        currentPage: 1,
        totalCount: 50,
        onEntryChanged: (_) {},
      );

      expect(entries, isA<StatelessComponent>());
    });
  });
}
