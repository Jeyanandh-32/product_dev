import 'package:test/test.dart';

class DropdownItem<T> {
  final String label;
  final T? value;

  const DropdownItem({required this.label, required this.value});
}

void main() {
  group('Report Filter Dropdown Tests', () {
    test('DropdownItem models values and labels correctly', () {
      const itemAll = DropdownItem<String>(
        label: 'All Payment Modes',
        value: null,
      );
      const itemCash = DropdownItem<String>(label: 'Cash', value: 'cash');
      const itemUpi = DropdownItem<String>(label: 'UPI', value: 'upi');

      expect(itemAll.label, equals('All Payment Modes'));
      expect(itemAll.value, isNull);
      expect(itemCash.value, equals('cash'));
      expect(itemUpi.value, equals('upi'));
    });

    test('Selected item resolution logic matches current value', () {
      final items = [
        const DropdownItem<String>(label: 'All Statuses', value: null),
        const DropdownItem<String>(label: 'Completed', value: 'completed'),
        const DropdownItem<String>(label: 'Pending', value: 'pending'),
      ];

      String computeLabel(String? currentValue) {
        final selectedItem = items.firstWhere(
          (item) => item.value == currentValue,
          orElse: () => items.first,
        );
        return currentValue == null
            ? 'Status: All'
            : 'Status: ${selectedItem.label}';
      }

      expect(computeLabel(null), equals('Status: All'));
      expect(computeLabel('completed'), equals('Status: Completed'));
      expect(computeLabel('pending'), equals('Status: Pending'));
      expect(computeLabel('unknown'), equals('Status: All Statuses'));
    });

    test('Boolean status filter label logic', () {
      String getStatusLabel(bool? status) => switch (status) {
        true => 'Status: Active',
        false => 'Status: Inactive',
        null => 'Status: All',
      };

      expect(getStatusLabel(null), equals('Status: All'));
      expect(getStatusLabel(true), equals('Status: Active'));
      expect(getStatusLabel(false), equals('Status: Inactive'));
    });
  });
}
