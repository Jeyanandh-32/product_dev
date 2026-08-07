import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final categoriesPageSignal = signal<int>(1);
final categoriesTotalSignal = signal<int>(0);
final categoriesTotalPagesSignal = signal<int>(1);
final categorySearchSignal = signal<String>('');
final editingCategorySignal = signal<Category?>(null);

final categoriesSignal = asyncSignal<List<Category>>(const AsyncLoading());

Future<void> refreshCategoriesSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    untracked(() {
      categoriesSignal.value = const AsyncData([]);
    });
    return;
  }

  untracked(() {
    categoriesSignal.value = const AsyncLoading();
  });

  final size = entriesSignal.value;
  final page = categoriesPageSignal.value;

  try {
    final search = categorySearchSignal.value.trim();

    final result = await CategoryRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
      search: search.isNotEmpty ? search : null,
    );

    categoriesTotalSignal.value = result.totalItems;
    categoriesTotalPagesSignal.value = result.totalPages;
    categoriesSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    categoriesSignal.value = AsyncError(e, stack);
  }
}

abstract final class CategoriesActions {
  static Future<void> create({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final selectedStore = storeSignal.value;
    if (selectedStore == null) return;

    final currentCategories = categoriesSignal.value.value ?? [];
    untracked(() {
      categoriesSignal.value = const AsyncLoading();
    });

    try {
      final category = await CategoryRepository.create(
        storeId: selectedStore.id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );

      categoriesSignal.value = AsyncData([...currentCategories, category]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      categoriesSignal.value = AsyncData(currentCategories);
    }
  }

  static Future<void> updateCategory({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) async {
    final currentCategories = categoriesSignal.value.value ?? [];
    untracked(() {
      categoriesSignal.value = const AsyncLoading();
    });

    try {
      final updatedCategory = await CategoryRepository.update(
        id: id,
        name: name,
        isActive: isActive,
        description: description,
        imageUrl: imageUrl,
      );

      categoriesSignal.value = AsyncData(
        currentCategories.map((s) => s.id == id ? updatedCategory : s).toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      categoriesSignal.value = AsyncData(currentCategories);
    }
  }
}
