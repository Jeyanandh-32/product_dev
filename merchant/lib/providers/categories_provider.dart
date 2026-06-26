import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/repositories/category_repository.dart';
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
    try {
      return await CategoryRepository.getAll(storeId: selectedStore.id);
    } catch (e) {
      return [];
    }
  }

  Future<void> create({required String name}) async {
    final selectedStore = ref.read(storeProvider);
    if (selectedStore == null) return;

    final currentCategories = state.value ?? [];
    state = const AsyncLoading();

    try {
      final category = await CategoryRepository.create(
        storeId: selectedStore.id,
        name: name,
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
  }) async {
    final currentCategories = state.value ?? [];
    state = const AsyncLoading();

    try {
      final updatedCategory = await CategoryRepository.update(
        id: id,
        name: name,
        isActive: isActive,
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
