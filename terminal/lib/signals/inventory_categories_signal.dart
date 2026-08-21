import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/products_signal.dart';

enum CategorySortKey {
  name('Name'),
  status('Status'),
  productCount('Associated Products'),
  description('Description');

  final String label;
  const CategorySortKey(this.label);
}

class CategorySortState {
  final CategorySortKey? key;
  final bool isAscending;
  const CategorySortState({this.key, this.isAscending = true});

  CategorySortState toggle(CategorySortKey newKey) {
    if (key == newKey) {
      if (isAscending) return CategorySortState(key: newKey, isAscending: false);
      return const CategorySortState(key: null, isAscending: true);
    }
    return CategorySortState(key: newKey, isAscending: true);
  }
}

final categorySearchSignal = signal<String>('');
final categoryStatusFilterSignal = signal<bool?>(null);
final categorySortStateSignal = signal<CategorySortState>(const CategorySortState());
final categoryEntriesSignal = signal<int>(10);
final categoryPageSignal = signal<int>(1);

final filteredCategoriesSignal = computed<List<Category>>(() {
  final categories = categoriesSignal.value.value ?? [];
  final search = categorySearchSignal.value.trim().toLowerCase();
  final status = categoryStatusFilterSignal.value;
  final sortState = categorySortStateSignal.value;
  final allProducts = productsSignal.value.value ?? [];

  final filtered = categories.where((c) {
    if (search.isNotEmpty) {
      final nameMatches = c.name.toLowerCase().contains(search);
      final descMatches = c.description?.toLowerCase().contains(search) ?? false;
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
      CategorySortKey.name => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      CategorySortKey.status => (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0),
      CategorySortKey.productCount => allProducts.where((p) => p.category?.id == a.id).length.compareTo(allProducts.where((p) => p.category?.id == b.id).length),
      CategorySortKey.description => (a.description ?? '').toLowerCase().compareTo((b.description ?? '').toLowerCase()),
    };
    return isAsc ? cmp : -cmp;
  });

  return filtered;
});

final categoryTotalPagesSignal = computed<int>(() {
  final total = filteredCategoriesSignal.value.length;
  final entries = categoryEntriesSignal.value;
  if (total == 0) return 1;
  return (total / entries).ceil();
});

final pagedCategoriesSignal = computed<List<Category>>(() {
  final filtered = filteredCategoriesSignal.value;
  final entries = categoryEntriesSignal.value;
  final page = categoryPageSignal.value;
  final startIndex = (page - 1) * entries;
  if (startIndex >= filtered.length) return [];
  final endIndex = (startIndex + entries).clamp(0, filtered.length);
  return filtered.sublist(startIndex, endIndex);
});

abstract final class CategoryActions {
  static Future<Category> create({required String name, String? description, String? imageUrl}) async {
    final terminal = authSignal.value.value;
    if (terminal == null) throw const ApiException('Terminal not logged in.');
    final category = await CategoryRepository.create(storeId: terminal.storeId, name: name, description: description, imageUrl: imageUrl);
    final current = categoriesSignal.value.value ?? [];
    categoriesSignal.value = AsyncData([...current, category]);
    return category;
  }

  static Future<Category> update({required String id, String? name, bool? isActive, String? description, String? imageUrl}) async {
    final updated = await CategoryRepository.update(id: id, name: name, isActive: isActive, description: description, imageUrl: imageUrl);
    final current = categoriesSignal.value.value ?? [];
    categoriesSignal.value = AsyncData(current.map((c) => c.id == id ? updated : c).toList());
    return updated;
  }
}

/// Resets inventory category search, filter, sort state, and pagination.
void resetInventoryCategoriesSignal() {
  categorySearchSignal.value = '';
  categoryStatusFilterSignal.value = null;
  categorySortStateSignal.value = const CategorySortState();
  categoryEntriesSignal.value = 10;
  categoryPageSignal.value = 1;
}
