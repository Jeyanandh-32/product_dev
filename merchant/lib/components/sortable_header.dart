import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List;

enum SortDirection {
  asc,
  desc,
  none;

  SortDirection next() => switch (this) {
    .none => .asc,
    .asc => .desc,
    .desc => .none,
  };
}

class SortState<K extends Enum> {
  const SortState({this.key, this.direction = SortDirection.none});

  final K? key;
  final SortDirection direction;

  SortState<K> toggle(K newKey) {
    if (key == newKey) {
      final nextDir = direction.next();
      return nextDir == SortDirection.none
          ? SortState<K>()
          : SortState<K>(key: newKey, direction: nextDir);
    }
    return SortState<K>(key: newKey, direction: SortDirection.asc);
  }
}

class SortableHeader<K extends Enum> extends StatelessComponent {
  const SortableHeader({
    super.key,
    required this.title,
    required this.sortKey,
    required this.currentSort,
    required this.onSort,
    this.isTh = false,
    this.classes = '',
  });

  final String title;
  final K sortKey;
  final SortState<K> currentSort;
  final void Function(K key) onSort;
  final bool isTh;
  final String classes;

  @override
  Component build(BuildContext context) {
    final isActive = currentSort.key == sortKey;
    final direction = isActive ? currentSort.direction : SortDirection.none;

    final icon = switch (direction) {
      .asc => ArrowUp(classes: 'w-3.5 h-3.5 text-primary ml-1.5 shrink-0'),
      .desc => ArrowDown(classes: 'w-3.5 h-3.5 text-primary ml-1.5 shrink-0'),
      .none => ArrowUpDown(
        classes:
            'w-3.5 h-3.5 text-gray-400 group-hover:text-gray-600 ml-1.5 shrink-0 opacity-0 group-hover:opacity-100 transition-opacity',
      ),
    };

    final content = div(
      classes: 'flex items-center space-x-1 whitespace-nowrap',
      [
        span(classes: isActive ? 'font-bold text-primary' : '', [
          .text(title),
        ]),
        icon,
      ],
    );

    final headerClasses =
        'cursor-pointer select-none group hover:bg-base-200/60 transition-colors whitespace-nowrap $classes';

    return isTh
        ? th(
            classes: headerClasses,
            events: {'click': (_) => onSort(sortKey)},
            [content],
          )
        : td(
            classes: headerClasses,
            events: {'click': (_) => onSort(sortKey)},
            [content],
          );
  }
}

List<T> sortItems<T, K extends Enum>({
  required List<T> items,
  required SortState<K> sortState,
  required Comparable<dynamic>? Function(T item, K key) getSortValue,
}) {
  if (sortState.key == null || sortState.direction == SortDirection.none) {
    return items;
  }

  final sorted = List<T>.from(items);
  final key = sortState.key!;
  final isAsc = sortState.direction == SortDirection.asc;

  sorted.sort((itemA, itemB) {
    final valA = getSortValue(itemA, key);
    final valB = getSortValue(itemB, key);

    if (valA == null && valB == null) return 0;
    if (valA == null) return isAsc ? 1 : -1;
    if (valB == null) return isAsc ? -1 : 1;

    final result = valA.compareTo(valB);
    return isAsc ? result : -result;
  });

  return sorted;
}
