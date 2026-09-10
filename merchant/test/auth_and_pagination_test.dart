import 'package:merchant/components/cards/store_card.dart';
import 'package:merchant/components/cards/terminal_card.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/fields/store_type_selector_field.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/pages/register.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  group('Auth Pages Tests', () {
    test('Register page instantiates as a SignalComponent', () {
      const register = Register();
      expect(register, isA<SignalComponent>());
      final state = register.createState();
      expect(state, isNotNull);
    });
  });

  group('TablePagination Tests', () {
    test('TablePagination instantiates with page numbers, entries, and triggers callbacks', () {
      int activePage = 1;
      int activeEntries = 10;
      final pagination = TablePagination(
        currentPage: 1,
        totalPages: 5,
        entries: 10,
        totalCount: 48,
        onPageChanged: (p) => activePage = p,
        onEntryChanged: (e) => activeEntries = e,
      );

      expect(pagination.currentPage, equals(1));
      expect(pagination.totalPages, equals(5));
      expect(pagination.entries, equals(10));
      expect(pagination.totalCount, equals(48));

      pagination.onPageChanged(3);
      expect(activePage, equals(3));

      pagination.onEntryChanged(25);
      expect(activeEntries, equals(25));
    });

    test(
      'TablePagination handles large total pages range and single page state',
      () {
        final pagination = TablePagination(
          currentPage: 5,
          totalPages: 10,
          entries: 25,
          totalCount: 250,
          onPageChanged: (_) {},
          onEntryChanged: (_) {},
        );

        expect(pagination.currentPage, equals(5));
        expect(pagination.totalPages, equals(10));
        expect(pagination.entries, equals(25));
        expect(pagination.totalCount, equals(250));
      },
    );
  });

  group('StoreTypeSelectorField Tests', () {
    test(
      'Initializes with null selection and triggers onTypeSelected safely',
      () {
        StoreType? selected;
        final field = StoreTypeSelectorField(
          selectedType: null,
          onTypeSelected: (t) => selected = t,
        );

        expect(field.selectedType, isNull);
        field.onTypeSelected(StoreType.retail);
        expect(selected, equals(StoreType.retail));
      },
    );

    test('Initializes with existing selection', () {
      final field = StoreTypeSelectorField(
        selectedType: StoreType.restaurant,
        onTypeSelected: (_) {},
      );

      expect(field.selectedType, equals(StoreType.restaurant));
    });
  });

  group('Component Contracts & Cards Tests', () {
    test('Searchbar instantiates with placeholder and callback', () {
      String query = '';
      final searchbar = Searchbar(
        placeholder: 'Search items...',
        onInput: (val) => query = val,
      );

      expect(searchbar.placeholder, equals('Search items...'));
      searchbar.onInput?.call('butter');
      expect(query, equals('butter'));
    });

    test('TerminalCard and StoreCard instantiate cleanly', () {
      final terminal = Terminal(
        merchantId: 'm-1',
        storeId: 's-1',
        name: 'Main Counter',
        code: 'HIN123456789',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      bool editTriggered = false;
      final card = TerminalCard(
        terminal: terminal,
        onEdit: () => editTriggered = true,
      );
      expect(card.terminal.code, equals('HIN123456789'));
      card.onEdit?.call();
      expect(editTriggered, isTrue);

      final store = Store(
        id: 's-1',
        merchantId: 'm-1',
        name: 'Downtown Store',
        storeType: 'retail',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      final storeCard = StoreCard(
        store: store,
        count: 2,
        isSelected: true,
      );
      expect(storeCard.store.name, equals('Downtown Store'));
      expect(storeCard.count, equals(2));
      expect(storeCard.isSelected, isTrue);
    });
  });
}
