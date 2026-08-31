/// Transaction type for bottle return reward credits and debits.
enum BottleCreditTransactionType {
  /// Credit added when bottles are returned.
  credit,

  /// Debit applied when credits are used for order discounts.
  debit;

  /// Parses transaction type from raw string.
  static BottleCreditTransactionType fromString(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'debit' => BottleCreditTransactionType.debit,
      _ => BottleCreditTransactionType.credit,
    };
  }
}
