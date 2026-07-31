import 'dart:async';

import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/config/secure_storage.dart';
import 'package:terminal/repositories/terminal_repository.dart';

final authSignal = asyncSignal<Terminal?>(const AsyncLoading());

Future<void> initAuthSignal() async {
  try {
    final terminal = await TerminalAuthRepository.getTerminal();
    authSignal.value = AsyncData(terminal);
  } catch (e, stack) {
    authSignal.value = AsyncError(e, stack);
  }
}

Future<void> loginTerminal({
  required String code,
  required String password,
}) async {
  authSignal.value = const AsyncLoading();
  try {
    final terminal = await TerminalAuthRepository.login(
      code: code,
      password: password,
    );
    authSignal.value = AsyncData(terminal);
  } catch (e, stack) {
    authSignal.value = AsyncError(e, stack);
    rethrow;
  }
}

Future<void> logoutTerminal() async {
  await SecureStorage.deleteAccessToken();
  authSignal.value = const AsyncData(null);
}
