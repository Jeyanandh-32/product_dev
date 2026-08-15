import 'package:models/models.dart';

/// Formatting utilities for payments report presentation.
class PaymentFormatter {
  const PaymentFormatter._();

  /// Converts payment method enum to user-facing code label.
  static String formatPaymentType(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'CASH',
      PaymentMethod.upi => 'UPI',
      PaymentMethod.complimentary => 'FREE',
    };
  }

  /// Returns user-facing label and CSS badge class for payment status.
  static (String label, String badgeClass) formatPaymentStatus(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.completed => (
        'COMPLETED',
        'bg-soft-green text-soft-green-content',
      ),
      PaymentStatus.pending => (
        'PENDING',
        'bg-soft-yellow text-soft-yellow-content',
      ),
      PaymentStatus.failed => (
        'FAILED',
        'bg-soft-red text-soft-red-content',
      ),
    };
  }
}
