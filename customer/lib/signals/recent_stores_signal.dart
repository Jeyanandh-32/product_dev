import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

/// Signal holding list of recently visited stores for the authenticated customer.
final recentStoresSignal = asyncSignal<List<Store>>(const AsyncData([]));

/// Refreshes the recent stores signal by querying the backend repository.
Future<void> refreshRecentStoresSignal() async {
  final customer = customerAuthSignal.value.value;
  if (customer == null) {
    recentStoresSignal.value = const AsyncData([]);
    return;
  }

  try {
    final stores = await CustomerAuthRepository.getRecentStores();
    recentStoresSignal.value = AsyncData(stores);
  } catch (e, stack) {
    recentStoresSignal.value = AsyncError(e, stack);
  }
}

/// Records a visit to [storeId] on the backend and immediately updates the cached recent stores list.
Future<void> recordStoreVisitSignal(String storeId) async {
  final customer = customerAuthSignal.value.value;
  if (customer == null) return;

  try {
    await CustomerAuthRepository.recordStoreVisit(storeId);
    await refreshRecentStoresSignal();
  } catch (_) {}
}
