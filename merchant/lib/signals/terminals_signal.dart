import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final editingTerminalSignal = signal<Terminal?>(null);

final terminalsSignal = asyncSignal<List<Terminal>>(const AsyncLoading());

void resetTerminalsSignal() {
  editingTerminalSignal.value = null;
  terminalsSignal.value = const AsyncData([]);
}

Future<void> refreshTerminalsSignal() async {
  untracked(() {
    terminalsSignal.value = const AsyncLoading();
  });
  try {
    final terminals = await TerminalRepository.getAll();
    terminalsSignal.value = AsyncData(terminals);
  } catch (e, stack) {
    terminalsSignal.value = AsyncError(e, stack);
  }
}

abstract final class TerminalsActions {
  static Future<void> create({
    required String name,
    required String password,
  }) async {
    final selectedStore = selectedTabStoreSignal.value;
    if (selectedStore == null) return;

    final currentTerminals = terminalsSignal.value.value ?? [];
    untracked(() {
      terminalsSignal.value = const AsyncLoading();
    });

    try {
      final terminal = await TerminalRepository.create(
        storeId: selectedStore.id,
        name: name,
        password: password,
      );

      terminalsSignal.value = AsyncData([...currentTerminals, terminal]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      terminalsSignal.value = AsyncData(currentTerminals);
    }
  }

  static Future<void> updateStatus({
    required String code,
    required bool isActive,
  }) async {
    final currentTerminals = terminalsSignal.value.value ?? [];

    try {
      final updatedTerminal = await TerminalRepository.update(
        code: code,
        isActive: isActive,
      );

      terminalsSignal.value = AsyncData(
        currentTerminals
            .map((t) => t.code == code ? updatedTerminal : t)
            .toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);
    }
  }

  static Future<void> updateTerminal({
    required String code,
    String? name,
    String? password,
    bool? isActive,
  }) async {
    final currentTerminals = terminalsSignal.value.value ?? [];
    untracked(() {
      terminalsSignal.value = const AsyncLoading();
    });

    try {
      final updatedTerminal = await TerminalRepository.update(
        code: code,
        name: name,
        password: password,
        isActive: isActive,
      );

      terminalsSignal.value = AsyncData(
        currentTerminals
            .map((t) => t.code == code ? updatedTerminal : t)
            .toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      terminalsSignal.value = AsyncData(currentTerminals);
    }
  }
}
