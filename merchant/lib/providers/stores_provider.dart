import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/repositories/auth_repository.dart';
import 'package:merchant/repositories/store_repository.dart';
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
}
