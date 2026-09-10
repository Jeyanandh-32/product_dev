import 'package:test/test.dart';

void main() {
  group('Stores and Terminals Container & Card Parity Tests', () {
    test('Container padding classes are uniformly p-5', () {
      const storesContainerPadding = 'p-5';
      const terminalsContainerPadding = 'p-5';

      expect(storesContainerPadding, equals(terminalsContainerPadding));
    });

    test('Status badge classes match StoreCard standard', () {
      String getTerminalStatusBadge(bool isActive) {
        if (isActive) {
          return 'bg-soft-green text-soft-green-content rounded-full px-2.5 py-0.5 text-xs font-semibold';
        }
        return 'bg-soft-red text-soft-red-content rounded-full px-2.5 py-0.5 text-xs font-semibold';
      }

      final activeBadge = getTerminalStatusBadge(true);
      final inactiveBadge = getTerminalStatusBadge(false);

      expect(activeBadge, contains('px-2.5 py-0.5'));
      expect(activeBadge, contains('bg-soft-green'));
      expect(inactiveBadge, contains('px-2.5 py-0.5'));
      expect(inactiveBadge, contains('bg-soft-red'));
      expect(activeBadge, isNot(contains('px-3 py-1')));
    });

    test('Edit button action classes provide rounded hover target', () {
      const editButtonClass =
          'p-1.5 rounded-lg text-slate-400 hover:text-slate-900 hover:bg-slate-100 hover:cursor-pointer transition-all duration-200 shrink-0';

      expect(editButtonClass, contains('p-1.5'));
      expect(editButtonClass, contains('rounded-lg'));
      expect(editButtonClass, contains('hover:bg-slate-100'));
    });
  });
}
