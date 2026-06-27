import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:terminal/config/secure_storage.dart';
import 'package:terminal/repositories/terminal_repository.dart';

class AuthProvider extends AsyncNotifier<Terminal?> {
  @override
  FutureOr<Terminal?> build() async {
    try {
      return await TerminalRepository.getTerminal();
    } catch (_) {
      return null;
    }
  }

  Future<void> login({required String code, required String password}) async {
    state = const AsyncLoading();
    try {
      final terminal = await TerminalRepository.login(
        code: code,
        password: password,
      );
      state = AsyncData(terminal);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await SecureStorage.deleteAccessToken();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthProvider, Terminal?>(
  () => AuthProvider(),
);
