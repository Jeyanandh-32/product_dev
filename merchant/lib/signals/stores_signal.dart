import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final storeSignal = signal<Store?>(null);
final selectedTabStoreSignal = signal<Store?>(null);
final editingStoreSignal = signal<Store?>(null);

final storesSignal = asyncSignal<List<Store>>(const AsyncLoading());

Future<void> refreshStoresSignal() async {
  untracked(() {
    storesSignal.value = const AsyncLoading();
  });
  try {
    final stores = await StoreRepository.getAll();
    storesSignal.value = AsyncData(stores);
    if (stores.isNotEmpty) {
      final currentStore = storeSignal.value;
      if (currentStore == null || !stores.any((s) => s.id == currentStore.id)) {
        storeSignal.value = stores.first;
      }
    }
  } catch (e, stack) {
    storesSignal.value = AsyncError(e, stack);
  }
}

abstract final class StoresActions {
  static Future<void> create({required String name, String? storeType}) async {
    final currentStores = storesSignal.value.value ?? [];
    untracked(() {
      storesSignal.value = const AsyncLoading();
    });

    try {
      final store = await StoreRepository.create(
        name: name,
        storeType: storeType,
      );

      storesSignal.value = AsyncData([...currentStores, store]);
      if (storeSignal.value == null) {
        storeSignal.value = store;
      }
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      storesSignal.value = AsyncData(currentStores);
    }
  }

  static Future<void> updateStore({
    required String id,
    String? name,
    String? storeType,
    bool? isActive,
  }) async {
    final currentStores = storesSignal.value.value ?? [];
    untracked(() {
      storesSignal.value = const AsyncLoading();
    });

    try {
      final updatedStore = await StoreRepository.update(
        id: id,
        name: name,
        storeType: storeType,
        isActive: isActive,
      );

      storesSignal.value = AsyncData(
        currentStores.map((s) => s.id == id ? updatedStore : s).toList(),
      );

      final selectedStore = selectedTabStoreSignal.value;
      if (selectedStore != null && selectedStore.id == id) {
        selectedTabStoreSignal.value = updatedStore;
      }

      final activeStore = storeSignal.value;
      if (activeStore != null && activeStore.id == id) {
        storeSignal.value = updatedStore;
      }
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      storesSignal.value = AsyncData(currentStores);
    }
  }
}
