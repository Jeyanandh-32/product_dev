import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/repositories/auth_repository.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/dashboard_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/orders_signal.dart';
import 'package:merchant/signals/payments_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/profit_loss_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stock_summary_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/terminals_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final authSignal = asyncSignal<Merchant?>(const AsyncLoading());
final authSubmittingSignal = signal<bool>(false);

void resetAllMerchantSignals() {
  resetStoresSignal();
  resetCategoriesSignal();
  resetCountersSignal();
  resetProductsSignal();
  resetDashboardSignal();
  resetOrdersSignal();
  resetPaymentsSignal();
  resetProfitLossSignal();
  resetStockSummarySignal();
  resetTerminalsSignal();
  resetNavigationSignal();
  resetReportsDateSignal();
}

Future<void> initAuthSignal() async {
  try {
    final merchant = await MerchantRepository.getMerchant();
    authSignal.value = AsyncData(merchant);
    if (merchant != null) {
      refreshStoresSignal();
    } else {
      resetAllMerchantSignals();
    }
  } catch (e, stack) {
    authSignal.value = AsyncError(e, stack);
  }
}

Future<void> getMerchant() async {
  authSignal.value = const AsyncLoading();
  try {
    final merchant = await MerchantRepository.getMerchant();
    authSignal.value = AsyncData(merchant);
    if (merchant != null) {
      refreshStoresSignal();
    } else {
      resetAllMerchantSignals();
    }
  } catch (e, stack) {
    authSignal.value = AsyncError(e, stack);
  }
}

Future<void> loginMerchant({
  required String email,
  required String password,
}) async {
  authSubmittingSignal.value = true;
  resetAllMerchantSignals();
  try {
    final merchant = await AuthRepository.login(
      email: email,
      password: password,
    );
    authSignal.value = AsyncData(merchant);
    if (merchant != null) {
      refreshStoresSignal();
    }
  } on ApiException catch (e) {
    showToast(e.message);
    authSignal.value = const AsyncData(null);
  } catch (_) {
    showToast('Something went wrong.');
    authSignal.value = const AsyncData(null);
  } finally {
    authSubmittingSignal.value = false;
  }
}

Future<void> registerMerchant({
  required String name,
  required String businessName,
  required String whatsappNumber,
  required String email,
  required String password,
}) async {
  authSubmittingSignal.value = true;
  resetAllMerchantSignals();
  try {
    final merchant = await AuthRepository.register(
      name: name,
      businessName: businessName,
      whatsappNumber: whatsappNumber,
      email: email,
      password: password,
    );
    authSignal.value = AsyncData(merchant);
    refreshStoresSignal();
  } on ApiException catch (e) {
    showToast(e.message);
    authSignal.value = const AsyncData(null);
  } catch (_) {
    showToast('Something went wrong.');
    authSignal.value = const AsyncData(null);
  } finally {
    authSubmittingSignal.value = false;
  }
}

Future<void> logoutMerchant() async {
  try {
    await AuthRepository.logout();
  } on ApiException catch (e) {
    showToast(e.message);
  } catch (_) {
    showToast('Something went wrong.');
  } finally {
    clearLastSelectedStoreId();
    authSignal.value = const AsyncData(null);
    resetAllMerchantSignals();
  }
}
