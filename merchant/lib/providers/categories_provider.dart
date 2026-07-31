import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';

final categoriesProvider =
    AsyncNotifierProvider.autoDispose<CategoriesProvider, List<Category>>(
      () => CategoriesProvider(),
    );

class CategoriesProvider extends AsyncNotifier<List<Category>> {
  @override
  FutureOr<List<Category>> build() async {
    final selectedStore = ref.watch(storeProvider);
    if (selectedStore == null) return [];

    final size = ref.watch(entriesProvider);
    final page = ref.watch(categoriesPageProvider);

    final result = await CategoryRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
    );

    ref.read(categoriesTotalProvider.notifier).state = result.totalItems;
    ref.read(categoriesTotalPagesProvider.notifier).state = result.totalPages;

    return result.items;
  }

  Future<void> create({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final selectedStore = ref.read(storeProvider);
    if (selectedStore == null) return;

    final currentCategories = state.value ?? [];
    state = const AsyncLoading();

    try {
      final category = await CategoryRepository.create(
        storeId: selectedStore.id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );

      state = AsyncData([...currentCategories, category]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentCategories);
    }
  }

  Future<void> updateCategory({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) async {
    final currentCategories = state.value ?? [];
    state = const AsyncLoading();

    try {
      final updatedCategory = await CategoryRepository.update(
        id: id,
        name: name,
        isActive: isActive,
        description: description,
        imageUrl: imageUrl,
      );

      state = AsyncData(
        currentCategories.map((s) => s.id == id ? updatedCategory : s).toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentCategories);
    }
  }
}
