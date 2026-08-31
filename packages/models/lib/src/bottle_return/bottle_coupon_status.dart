/// Lifecycle status of a physical bottle return paper coupon.
enum BottleCouponStatus {
  /// Active and ready to be redeemed.
  active,

  /// Redeemed against an order.
  redeemed,

  /// Expired or voided.
  expired;

  /// Parses status from raw string.
  static BottleCouponStatus fromString(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'redeemed' => BottleCouponStatus.redeemed,
      'expired' => BottleCouponStatus.expired,
      _ => BottleCouponStatus.active,
    };
  }
}
