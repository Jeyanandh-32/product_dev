import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/repositories/terminal_repository.dart';
import 'package:models/models.dart';

final terminalsProvider =
    AsyncNotifierProvider.autoDispose<TerminalsProvider, List<Terminal>>(
      () => TerminalsProvider(),
    );

class TerminalsProvider extends AsyncNotifier<List<Terminal>> {
  @override
  FutureOr<List<Terminal>> build() async {
    try {
      return await TerminalRepository.getAll();
    } catch (e) {
      return [];
    }
  }

  Future<void> create({required String name, required String password}) async {
    final selectedStore = ref.read(selectedTabStoreProvider);
    if (selectedStore == null) return;

    final currentTerminals = state.value ?? [];
    state = const AsyncLoading();

    try {
      final terminal = await TerminalRepository.create(
        storeId: selectedStore.id,
        name: name,
        password: password,
      );

      state = AsyncData([...currentTerminals, terminal]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentTerminals);
    }
  }

  Future<void> updateStatus({
    required String code,
    required bool isActive,
  }) async {
    final currentTerminals = state.value ?? [];

    try {
      final updatedTerminal = await TerminalRepository.update(
        code: code,
        isActive: isActive,
      );

      state = AsyncData(
        currentTerminals
            .map((t) => t.code == code ? updatedTerminal : t)
            .toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);
    }
  }

  Future<void> updateTerminal({
    required String code,
    String? name,
    String? password,
    bool? isActive,
  }) async {
    final currentTerminals = state.value ?? [];
    state = const AsyncLoading();

    try {
      final updatedTerminal = await TerminalRepository.update(
        code: code,
        name: name,
        password: password,
        isActive: isActive,
      );

      state = AsyncData(
        currentTerminals
            .map((t) => t.code == code ? updatedTerminal : t)
            .toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);

      state = AsyncData(currentTerminals);
    }
  }
}
