/// Order payment settlement status.
enum PaymentStatus {
  /// Payment has been successfully captured and completed.
  completed,

  /// Payment is pending capture or confirmation.
  pending,

  /// Payment failed or was rejected.
  failed;

  /// Whether this status represents a completed payment.
  bool get isPaid => this == PaymentStatus.completed;

  /// Whether this status represents a pending payment.
  bool get isPending => this == PaymentStatus.pending;

  /// Whether this status represents a failed payment.
  bool get isFailed => this == PaymentStatus.failed;

  /// Safe parser from string or wire value.
  static PaymentStatus? tryParse(String? value) {
    if (value == null) return null;
    final lower = value.toLowerCase().trim();
    if (lower == 'paid') return PaymentStatus.completed;
    if (lower == 'success') return PaymentStatus.completed;
    return PaymentStatus.values.asNameMap()[lower];
  }

  /// Deserializes JSON string value.
  static PaymentStatus? fromJson(dynamic json) => tryParse(json?.toString());
}

/// Convenience extensions for raw payment status strings.
extension PaymentStatusStringExtension on String {
  /// Checks whether this status string matches a paid status (completed or legacy paid).
  bool get isPaidStatus {
    final lower = toLowerCase().trim();
    return lower == PaymentStatus.completed.name || lower == 'paid';
  }
}

