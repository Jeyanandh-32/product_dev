import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/products_signal.dart';

enum CounterSortKey {
  name('Name'),
  status('Status'),
  productCount('Associated Products'),
  description('Description');

  final String label;
  const CounterSortKey(this.label);
}

class CounterSortState {
  final CounterSortKey? key;
  final bool isAscending;
  const CounterSortState({this.key, this.isAscending = true});

  CounterSortState toggle(CounterSortKey newKey) {
    if (key == newKey) {
      if (isAscending) return CounterSortState(key: newKey, isAscending: false);
      return const CounterSortState(key: null, isAscending: true);
    }
    return CounterSortState(key: newKey, isAscending: true);
  }
}

final counterSearchSignal = signal<String>('');
final counterStatusFilterSignal = signal<bool?>(null);
final counterSortStateSignal = signal<CounterSortState>(
  const CounterSortState(),
);
final counterEntriesSignal = signal<int>(10);
final counterPageSignal = signal<int>(1);

final filteredCountersSignal = computed<List<Counter>>(() {
  final counters = countersSignal.value.value ?? [];
  final search = counterSearchSignal.value.trim().toLowerCase();
  final status = counterStatusFilterSignal.value;
  final sortState = counterSortStateSignal.value;
  final allProducts = productsSignal.value.value ?? [];

  final filtered = counters.where((c) {
    if (search.isNotEmpty) {
      final nameMatches = c.name.toLowerCase().contains(search);
      final descMatches =
          c.description?.toLowerCase().contains(search) ?? false;
      if (!nameMatches && !descMatches) return false;
    }
    if (status != null && c.isActive != status) return false;
    return true;
  }).toList();

  final sortKey = sortState.key;
  if (sortKey == null) return filtered;

  final isAsc = sortState.isAscending;
  filtered.sort((a, b) {
    final cmp = switch (sortKey) {
      CounterSortKey.name => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
      CounterSortKey.status => (a.isActive ? 1 : 0).compareTo(
        b.isActive ? 1 : 0,
      ),
      CounterSortKey.productCount =>
        allProducts
            .where((p) => p.counter?.id == a.id)
            .length
            .compareTo(allProducts.where((p) => p.counter?.id == b.id).length),
      CounterSortKey.description =>
        (a.description ?? '').toLowerCase().compareTo(
          (b.description ?? '').toLowerCase(),
        ),
    };
    return isAsc ? cmp : -cmp;
  });

  return filtered;
});

final counterTotalPagesSignal = computed<int>(() {
  final total = filteredCountersSignal.value.length;
  final entries = counterEntriesSignal.value;
  if (total == 0) return 1;
  return (total / entries).ceil();
});

final pagedCountersSignal = computed<List<Counter>>(() {
  final filtered = filteredCountersSignal.value;
  final entries = counterEntriesSignal.value;
  final page = counterPageSignal.value;
  final startIndex = (page - 1) * entries;
  if (startIndex >= filtered.length) return [];
  final endIndex = (startIndex + entries).clamp(0, filtered.length);
  return filtered.sublist(startIndex, endIndex);
});

/// Resets inventory counter search, filter, sort state, and pagination.
void resetInventoryCountersSignal() {
  counterSearchSignal.value = '';
  counterStatusFilterSignal.value = null;
  counterSortStateSignal.value = const CounterSortState();
  counterEntriesSignal.value = 10;
  counterPageSignal.value = 1;
}
