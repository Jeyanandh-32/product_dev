import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/repositories/counter_repository.dart';
import 'package:models/models.dart';

final countersProvider =
    AsyncNotifierProvider.autoDispose<CountersProvider, List<Counter>>(
      () => CountersProvider(),
    );

class CountersProvider extends AsyncNotifier<List<Counter>> {
  @override
  FutureOr<List<Counter>> build() async {
    final selectedStore = ref.watch(storeProvider);
    if (selectedStore == null) return [];
    try {
      return await CounterRepository.getAll(storeId: selectedStore.id);
    } catch (e) {
      return [];
    }
  }

  Future<void> create({required String name}) async {
    final selectedStore = ref.read(storeProvider);
    if (selectedStore == null) return;

    final currentCounters = state.value ?? [];
    state = const AsyncLoading();

    try {
      final counter = await CounterRepository.create(
        storeId: selectedStore.id,
        name: name,
      );

      state = AsyncData([...currentCounters, counter]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentCounters);
    }
  }

  Future<void> updateCounter({
    required String id,
    String? name,
    bool? isActive,
  }) async {
    final currentCounters = state.value ?? [];
    state = const AsyncLoading();

    try {
      final updatedCounter = await CounterRepository.update(
        id: id,
        name: name,
        isActive: isActive,
      );

      state = AsyncData(
        currentCounters.map((s) => s.id == id ? updatedCounter : s).toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentCounters);
    }
  }
}
