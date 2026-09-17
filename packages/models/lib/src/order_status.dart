/// Lifecycle fulfillment status of an order.
enum OrderStatus {
  /// Order placed and awaiting preparation or payment.
  pending,

  /// Order is currently being prepared at the counter.
  preparing,

  /// Order has been fulfilled and completed.
  completed,

  /// Order was cancelled.
  cancelled;

  /// Convenience getters for order status.
  bool get isPending => this == pending;
  bool get isPreparing => this == preparing;
  bool get isCompleted => this == completed;
  bool get isCancelled => this == cancelled;

  /// Parses from string or wire value safely.
  static OrderStatus? tryParse(String? value) =>
      OrderStatus.values.asNameMap()[value?.toLowerCase().trim()];

  /// Deserializes JSON string value.
  static OrderStatus? fromJson(dynamic json) => tryParse(json?.toString());
}
