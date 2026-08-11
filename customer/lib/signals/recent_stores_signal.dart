import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final recentStoresSignal = asyncSignal<List<Store>>(const AsyncLoading());

Future<void> refreshRecentStoresSignal() async {
  try {
    final stores = await CustomerAuthRepository.getRecentStores();
    recentStoresSignal.value = AsyncData(stores);
  } catch (e, stack) {
    recentStoresSignal.value = AsyncError(e, stack);
  }
}

Future<void> recordStoreVisitSignal(String storeId) async {
  try {
    await CustomerAuthRepository.recordStoreVisit(storeId);
    await refreshRecentStoresSignal();
  } catch (_) {}
}
