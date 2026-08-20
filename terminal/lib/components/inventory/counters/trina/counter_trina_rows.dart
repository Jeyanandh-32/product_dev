import 'package:models/models.dart';
import 'package:trina_grid/trina_grid.dart';

/// Row transformer for inventory counters TrinaGrid.
class CounterTrinaRows {
  const CounterTrinaRows._();

  static List<TrinaRow> fromCounters(List<Counter> counters, List<Product> allProducts) {
    return counters.map((c) => buildRow(c, allProducts)).toList();
  }

  static TrinaRow buildRow(Counter c, List<Product> allProducts) {
    final count = allProducts.where((p) => p.counter?.id == c.id).length;

    return TrinaRow(
      cells: {
        'counter_ref': TrinaCell(value: c),
        'image': TrinaCell(value: c.imageUrl ?? ''),
        'name': TrinaCell(value: c.name),
        'status': TrinaCell(value: c.isActive),
        'products_count': TrinaCell(value: count),
        'description': TrinaCell(value: c.description ?? '-'),
      },
    );
  }
}
