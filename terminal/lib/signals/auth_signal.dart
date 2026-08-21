import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/config/secure_storage.dart';
import 'package:terminal/repositories/terminal_repository.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/signals/navigation_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/signals/products_signal.dart';

final authSignal = asyncSignal<Terminal?>(const AsyncLoading());

/// Resets all global reactive signals and caches across the terminal application.
void resetAllTerminalSignals() {
  resetCartSignal();
  resetProductsSignal();
  resetCategoriesSignal();
  resetCountersSignal();
  resetOrdersSignal();
  resetInventoryProductsSignal();
  resetInventoryCategoriesSignal();
  resetInventoryCountersSignal();
  resetNavigationSignal();
}

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
  try {
    final terminal = await TerminalAuthRepository.login(
      code: code,
      password: password,
    );
    resetAllTerminalSignals();
    authSignal.value = AsyncData(terminal);
  } catch (e) {
    authSignal.value = const AsyncData(null);
    rethrow;
  }
}

Future<void> logoutTerminal() async {
  await SecureStorage.deleteAccessToken();
  authSignal.value = const AsyncData(null);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    resetAllTerminalSignals();
  });
}
