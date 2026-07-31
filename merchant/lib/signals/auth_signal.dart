import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/repositories/auth_repository.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final authSignal = asyncSignal<Merchant?>(const AsyncLoading());

Future<void> initAuthSignal() async {
  try {
    final merchant = await MerchantRepository.getMerchant();
    authSignal.value = AsyncData(merchant);
    if (merchant != null) {
      refreshStoresSignal();
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
    }
  } catch (e, stack) {
    authSignal.value = AsyncError(e, stack);
  }
}

Future<void> loginMerchant({
  required String email,
  required String password,
}) async {
  authSignal.value = const AsyncLoading();
  try {
    final merchant = await AuthRepository.login(
      email: email,
      password: password,
    );
    authSignal.value = AsyncData(merchant);
    if (merchant != null) {
      refreshStoresSignal();
    }
  } catch (e) {
    final message = e is ApiException ? e.message : 'Something went wrong.';
    showToast(message);
    authSignal.value = const AsyncData(null);
  }
}

Future<void> registerMerchant({
  required String name,
  required String businessName,
  required String whatsappNumber,
  required String email,
  required String password,
}) async {
  authSignal.value = const AsyncLoading();
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
  } catch (e) {
    final message = e is ApiException ? e.message : 'Something went wrong.';
    showToast(message);
    authSignal.value = const AsyncData(null);
  }
}

Future<void> logoutMerchant() async {
  authSignal.value = const AsyncLoading();

  try {
    await AuthRepository.logout();
  } catch (e) {
    final message = e is ApiException ? e.message : 'Something went wrong.';
    showToast(message);
  } finally {
    authSignal.value = const AsyncData(null);
    storeSignal.value = null;
    selectedTabStoreSignal.value = null;
    storesSignal.value = const AsyncData([]);
  }
}
