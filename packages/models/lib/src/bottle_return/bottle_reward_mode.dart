/// Reward payout mode selected by the customer / cashier.
enum BottleRewardMode {
  /// Credit added directly to the merchant-wide customer phone wallet.
  digital,

  /// Printable paper voucher with unique redemption code.
  physical;

  /// Parses reward mode from raw string with fallback to digital.
  static BottleRewardMode fromString(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'physical' => BottleRewardMode.physical,
      _ => BottleRewardMode.digital,
    };
  }
}
