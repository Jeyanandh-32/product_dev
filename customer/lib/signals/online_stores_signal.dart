import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final onlineStoresSignal = asyncSignal<List<Store>>(const AsyncLoading());

Future<void> refreshOnlineStoresSignal() async {
  try {
    final stores = await StoreRepository.getOnlineStores();
    onlineStoresSignal.value = AsyncData(stores);
  } catch (e, stack) {
    onlineStoresSignal.value = AsyncError(e, stack);
  }
}
