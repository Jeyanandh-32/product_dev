import 'package:signals/signals.dart';

final toastSignal = signal<String?>(null);

void showToast(
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  toastSignal.value = message;
  Future.delayed(duration, () {
    toastSignal.value = null;
  });
}
