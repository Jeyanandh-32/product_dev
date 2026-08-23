/// Lifecycle status of a bottle QR token.
enum BottleTokenStatus {
  /// Token generated on sale; ready to be returned.
  active,

  /// Bottle has been returned and reward issued.
  returned,

  /// Order was cancelled or refunded.
  voided;

  /// Parses status from raw database string.
  static BottleTokenStatus fromString(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'returned' => BottleTokenStatus.returned,
      'voided' => BottleTokenStatus.voided,
      _ => BottleTokenStatus.active,
    };
  }
}
