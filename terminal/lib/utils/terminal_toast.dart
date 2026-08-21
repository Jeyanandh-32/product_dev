import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// Standardized toast notifications across the POS Terminal app.
abstract final class TerminalToast {
  /// Displays a standardized success toast notification with a green check icon.
  static void showSuccess({
    required BuildContext context,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    showFToast(
      context: context,
      alignment: .topCenter,
      duration: duration,
      icon: const Icon(
        FLucideIcons.circleCheck,
        color: Color(0xFF16A34A),
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF16A34A),
          fontWeight: FontWeight.bold,
        ),
      ),
      description: description != null ? Text(description) : null,
    );
  }

  /// Displays a standardized error toast notification with a red alert icon.
  static void showError({
    required BuildContext context,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    showFToast(
      context: context,
      alignment: .topCenter,
      duration: duration,
      icon: const Icon(
        FLucideIcons.circleAlert,
        color: Color(0xFFDC2626),
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFDC2626),
          fontWeight: FontWeight.bold,
        ),
      ),
      description: description != null ? Text(description) : null,
    );
  }

  /// Displays a standardized info / action required toast notification.
  static void showInfo({
    required BuildContext context,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    showFToast(
      context: context,
      alignment: .topCenter,
      duration: duration,
      icon: const Icon(
        FLucideIcons.info,
        color: Color(0xFF2563EB),
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2563EB),
          fontWeight: FontWeight.bold,
        ),
      ),
      description: description != null ? Text(description) : null,
    );
  }
}
