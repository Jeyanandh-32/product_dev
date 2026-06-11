import 'dart:async';

import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/repositories/auth_repository.dart';
import 'package:merchant/repositories/merchant_repository.dart';
import 'package:models/models.dart';

class AuthProvider extends AsyncNotifier<Merchant?> {
  @override
  FutureOr<Merchant?> build() async {
    try {
      return await MerchantRepository.getMerchant();
    } catch (_) {
      return null;
    }
  }

  Future<void> getMerchant() async {
    state = AsyncLoading();
    state = await AsyncValue.guard(
      () => MerchantRepository.getMerchant(),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = AsyncLoading();
    try {
      final merchant = await AuthRepository.login(
        email: email,
        password: password,
      );
      state = AsyncData(merchant);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);
      state = const AsyncData(null);
    }
  }

  Future<void> register({
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required String password,
  }) async {
    state = AsyncLoading();
    try {
      final merchant = await AuthRepository.register(
        name: name,
        businessName: businessName,
        whatsappNumber: whatsappNumber,
        email: email,
        password: password,
      );
      state = AsyncData(merchant);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);
      state = const AsyncData(null);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      await AuthRepository.logout();
      state = const AsyncData(null);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      ref.showToast(message);
      state = const AsyncData(null);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthProvider, Merchant?>(
  () => AuthProvider(),
);
