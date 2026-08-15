import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final customerAuthSignal = asyncSignal<Customer?>(const AsyncLoading());
final redirectPathSignal = signal<String?>(null);

Future<void> initCustomerAuthSignal() async {
  try {
    final customer = await CustomerAuthRepository.getCustomer();
    customerAuthSignal.value = AsyncData(customer);
  } catch (_) {
    // Unauthenticated guest user - proceed with null customer session
    customerAuthSignal.value = const AsyncData(null);
  }
}

Future<void> loginCustomer({
  required String mobileNumber,
  required String pin,
}) async {
  customerAuthSignal.value = const AsyncLoading();

  try {
    final customer = await CustomerAuthRepository.login(
      mobileNumber: mobileNumber,
      pin: pin,
    );

    customerAuthSignal.value = AsyncData(customer);
  } catch (e) {
    customerAuthSignal.value = const AsyncData(null);
    showCustomerToast(
      e.toString(),
      type: ToastType.error,
    );
  }
}

Future<void> registerCustomer({
  required String name,
  required String mobileNumber,
  required String pin,
}) async {
  customerAuthSignal.value = const AsyncLoading();

  try {
    final customer = await CustomerAuthRepository.register(
      name: name,
      mobileNumber: mobileNumber,
      pin: pin,
    );

    customerAuthSignal.value = AsyncData(customer);
  } catch (e) {
    customerAuthSignal.value = const AsyncData(null);
    showCustomerToast(
      e.toString(),
      type: ToastType.error,
    );
  }
}

Future<void> logoutCustomer() async {
  try {
    await CustomerAuthRepository.logout();
  } catch (_) {}
  customerAuthSignal.value = const AsyncData(null);
}

Future<bool> updateCustomerProfile({
  String? name,
  String? mobileNumber,
  String? pin,
  String? currentPin,
}) async {
  try {
    final updated = await CustomerAuthRepository.updateProfile(
      name: name,
      mobileNumber: mobileNumber,
      pin: pin,
      currentPin: currentPin,
    );

    customerAuthSignal.value = AsyncData(updated);
    showCustomerToast(
      'Profile updated successfully!',
      type: ToastType.success,
    );
    return true;
  } catch (e) {
    showCustomerToast(
      e.toString(),
      type: ToastType.error,
    );
    return false;
  }
}

Future<void> refreshCustomerAuthSignal() async {
  try {
    final customer = await CustomerAuthRepository.getCustomer();
    customerAuthSignal.value = AsyncData(customer);
  } catch (_) {}
}
