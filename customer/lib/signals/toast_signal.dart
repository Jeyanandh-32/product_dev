import 'package:signals/signals.dart';

enum ToastType {
  info,
  success,
  warning,
  error,
}

typedef ToastData = ({
  String message,
  ToastType type,
});

final customerToastSignal = signal<ToastData?>(null);

void showCustomerToast(
  String message, {
  ToastType type = ToastType.error,
  Duration duration = const Duration(seconds: 3),
}) {
  customerToastSignal.value = (message: message, type: type);
  Future.delayed(duration, () {
    customerToastSignal.value = null;
  });
}
