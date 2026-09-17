/// Direction or mode of a stock inventory adjustment.
enum StockTransactionType {
  /// Stock quantity is being increased.
  add,

  /// Stock quantity is being decreased.
  reduce,

  /// Stock quantity is being directly overwritten to a specific count.
  set,
}
