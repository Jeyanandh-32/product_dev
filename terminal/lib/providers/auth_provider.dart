import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:terminal/config/secure_storage.dart';
import 'package:terminal/repositories/terminal_repository.dart';

class AuthProvider extends AsyncNotifier<Terminal?> {
  @override
  FutureOr<Terminal?> build() async {
    await Future<void>.delayed(const Duration(seconds: 1));
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
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteAccessToken();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthProvider, Terminal?>(
  () => AuthProvider(),
);
