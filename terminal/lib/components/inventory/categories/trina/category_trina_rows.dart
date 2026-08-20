import 'package:models/models.dart';
import 'package:trina_grid/trina_grid.dart';

/// Row transformer for inventory categories TrinaGrid.
class CategoryTrinaRows {
  const CategoryTrinaRows._();

  static List<TrinaRow> fromCategories(List<Category> categories, List<Product> allProducts) {
    return categories.map((c) => buildRow(c, allProducts)).toList();
  }

  static TrinaRow buildRow(Category c, List<Product> allProducts) {
    final count = allProducts.where((p) => p.category?.id == c.id).length;

    return TrinaRow(
      cells: {
        'category_ref': TrinaCell(value: c),
        'action': TrinaCell(value: ''),
        'image': TrinaCell(value: c.imageUrl ?? ''),
        'name': TrinaCell(value: c.name),
        'status': TrinaCell(value: c.isActive),
        'products_count': TrinaCell(value: count),
        'description': TrinaCell(value: c.description ?? '-'),
      },
    );
  }
}
