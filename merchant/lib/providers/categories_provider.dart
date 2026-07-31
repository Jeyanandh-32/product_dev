import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final categoriesSignal = asyncSignal<List<Category>>(const AsyncLoading());

Future<void> refreshCategoriesSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    categoriesSignal.value = const AsyncData([]);
    return;
  }

  final size = entriesSignal.value;
  final page = categoriesPageSignal.value;

  try {
    final result = await CategoryRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
    );

    categoriesTotalSignal.value = result.totalItems;
    categoriesTotalPagesSignal.value = result.totalPages;
    categoriesSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    categoriesSignal.value = AsyncError(e, stack);
  }
}

class CategoriesActions {
  const CategoriesActions._();

  static Future<void> create({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final selectedStore = storeSignal.value;
    if (selectedStore == null) return;

    final currentCategories = categoriesSignal.value.value ?? [];
    categoriesSignal.value = const AsyncLoading();

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
    categoriesSignal.value = const AsyncLoading();

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
