/// Method used for order payment.
enum PaymentMethod {
  /// Cash on counter / physical payment.
  cash,

  /// Unified Payments Interface (digital QR / intent).
  upi,

  /// Complimentary zero-charge item / order.
  complimentary;

  /// Whether this is a cash transaction.
  bool get isCash => this == cash;

  /// Whether this is a digital UPI transaction.
  bool get isUpi => this == upi;

  /// Whether this is a complimentary order.
  bool get isComplimentary => this == complimentary;

  /// Safe parser from string or wire value.
  static PaymentMethod? tryParse(String? value) =>
      PaymentMethod.values.asNameMap()[value?.toLowerCase().trim()];

  /// Deserializes JSON string value.
  static PaymentMethod? fromJson(dynamic json) => tryParse(json?.toString());
}
