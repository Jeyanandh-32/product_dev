import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';

final storesProvider =
    AsyncNotifierProvider.autoDispose<StoresProvider, List<Store>>(
      () => StoresProvider(),
    );

class StoresProvider extends AsyncNotifier<List<Store>> {
  @override
  FutureOr<List<Store>> build() async {
    try {
      return await StoreRepository.getAll();
    } catch (e) {
      return [];
    }
  }

  Future<void> create({required String name, String? storeType}) async {
    final currentStores = state.value ?? [];
    state = const AsyncLoading();

    try {
      final store = await StoreRepository.create(
        name: name,
        storeType: storeType,
      );

      state = AsyncData([...currentStores, store]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentStores);
    }
  }

  Future<void> updateStore({
    required String id,
    String? name,
    String? storeType,
    bool? isActive,
  }) async {
    final currentStores = state.value ?? [];
    state = const AsyncLoading();

    try {
      final updatedStore = await StoreRepository.update(
        id: id,
        name: name,
        storeType: storeType,
        isActive: isActive,
      );

      state = AsyncData(
        currentStores.map((s) => s.id == id ? updatedStore : s).toList(),
      );

      final selectedStore = ref.read(selectedTabStoreProvider);
      if (selectedStore != null && selectedStore.id == id) {
        ref.read(selectedTabStoreProvider.notifier).state = updatedStore;
      }
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentStores);
    }
  }
}
