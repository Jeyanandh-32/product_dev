/// Reason or trigger for modifying stock inventory.
enum StockTransactionReason {
  /// Incoming inventory delivery or restocking.
  restock,

  /// Damaged, expired, or spilled product loss.
  wastage,

  /// Manual correction or audit inventory adjustment.
  adjustment,

  /// Inventory reduced due to a customer sale.
  sale,
}
