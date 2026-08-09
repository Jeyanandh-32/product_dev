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

final toastSignal = signal<ToastData?>(null);

void showToast(
  String message, {
  ToastType type = ToastType.error,
  Duration duration = const Duration(seconds: 3),
}) {
  toastSignal.value = (message: message, type: type);
  Future.delayed(duration, () {
    toastSignal.value = null;
  });
}
