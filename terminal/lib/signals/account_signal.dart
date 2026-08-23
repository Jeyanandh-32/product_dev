import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/repositories/terminal_repository.dart';

/// Global reactive signal holding the authenticated terminal's aggregated account information.
final terminalAccountSignal = asyncSignal<TerminalAccount?>(
  const AsyncLoading(),
);

/// Fetches and updates the terminal account signal with the latest store and merchant metadata.
Future<void> loadTerminalAccount() async {
  try {
    final account = await TerminalAuthRepository.getTerminalAccount();
    terminalAccountSignal.value = AsyncData(account);
  } catch (e, stack) {
    terminalAccountSignal.value = AsyncError(e, stack);
  }
}

/// Resets the terminal account signal cache on logout.
void resetAccountSignal() {
  terminalAccountSignal.value = const AsyncData(null);
}
