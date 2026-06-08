import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';

final toastProvider = StateProvider<String?>(
  (ref) => null,
);

extension ToastRefExtension on Ref {
  void showToast(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    read(toastProvider.notifier).state = message;
    Future.delayed(duration, () {
      read(toastProvider.notifier).state = null;
    });
  }
}
