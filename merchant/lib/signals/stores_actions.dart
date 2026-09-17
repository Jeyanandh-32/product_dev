import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Actions executor handling store creation and updates.
abstract final class StoresActions {
  /// Creates a new store and selects it if no store is currently active.
  static Future<void> create({
    required String name,
    StoreType? storeType,
    bool? isOnlineEnabled,
    String? slug,
  }) async {
    final currentStores = storesSignal.value.value ?? [];
    untracked(() {
      storesSignal.value = const AsyncLoading();
    });

    try {
      final store = await StoreRepository.create(
        name: name,
        storeType: storeType,
        isOnlineEnabled: isOnlineEnabled,
        slug: slug,
      );

      storesSignal.value = AsyncData([...currentStores, store]);
      if (storeSignal.value == null) {
        selectActiveStore(store);
      }
      showToast('Store created successfully.', type: ToastType.success);
    } on ApiException catch (e) {
      showToast(e.message);
      storesSignal.value = AsyncData(currentStores);
    } catch (_) {
      showToast('Something went wrong.');
      storesSignal.value = AsyncData(currentStores);
    }
  }

  /// Updates existing store attributes and updates reactive signals.
  static Future<void> updateStore({
    required String id,
    String? name,
    StoreType? storeType,
    bool? isActive,
    bool? isOnlineEnabled,
    String? slug,
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
        isOnlineEnabled: isOnlineEnabled,
        slug: slug,
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
      showToast('Store updated successfully.', type: ToastType.success);
    } on ApiException catch (e) {
      showToast(e.message);
      storesSignal.value = AsyncData(currentStores);
    } catch (_) {
      showToast('Something went wrong.');
      storesSignal.value = AsyncData(currentStores);
    }
  }
}
