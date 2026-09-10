import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';
import 'package:web/web.dart' as web;

export 'package:merchant/signals/stores_actions.dart';

final storeSignal = signal<Store?>(null);
final selectedTabStoreSignal = signal<Store?>(null);
final editingStoreSignal = signal<Store?>(null);

final storesSignal = asyncSignal<List<Store>>(const AsyncLoading());

const _lastStoreStorageKey = 'finch_last_selected_store_id';

/// Retrieves the persistent store ID from local storage.
String? getLastSelectedStoreId() {
  try {
    return web.window.localStorage.getItem(_lastStoreStorageKey);
  } catch (_) {
    return null;
  }
}

/// Persists the selected store ID into local storage.
void saveLastSelectedStoreId(String storeId) {
  try {
    web.window.localStorage.setItem(_lastStoreStorageKey, storeId);
  } catch (_) {}
}

/// Clears the saved store ID on explicit logout.
void clearLastSelectedStoreId() {
  try {
    web.window.localStorage.removeItem(_lastStoreStorageKey);
  } catch (_) {}
}

/// Sets the global active working store and persists the choice.
void selectActiveStore(Store store) {
  storeSignal.value = store;
  saveLastSelectedStoreId(store.id);
}

/// Sets the store selected specifically within the stores tab.
void selectTabStore(Store store) {
  selectedTabStoreSignal.value = store;
}

/// Resolves the global store to select, prioritizing saved storage ID, then active storeSignal, then first store.
Store resolvePreferredStore(List<Store> stores) {
  final savedId = getLastSelectedStoreId();
  if (savedId != null && savedId.isNotEmpty) {
    for (final s in stores) {
      if (s.id == savedId) return s;
    }
  }

  final current = storeSignal.value;
  if (current != null) {
    for (final s in stores) {
      if (s.id == current.id) return s;
    }
  }

  return stores.first;
}

void resetStoresSignal() {
  storeSignal.value = null;
  selectedTabStoreSignal.value = null;
  editingStoreSignal.value = null;
  storesSignal.value = const AsyncData([]);
}

Future<void> refreshStoresSignal() async {
  untracked(() {
    storesSignal.value = const AsyncLoading();
  });
  try {
    final stores = await StoreRepository.getAll();
    storesSignal.value = AsyncData(stores);
    if (stores.isNotEmpty) {
      selectActiveStore(resolvePreferredStore(stores));
    }
  } catch (e, stack) {
    storesSignal.value = AsyncError(e, stack);
  }
}
