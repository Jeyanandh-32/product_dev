/// Type of debit or credit activity occurring on a customer wallet.
enum WalletTransactionType {
  /// Money added to the customer wallet via payment gateway.
  topUp,

  /// Deduction from wallet to pay for an order.
  orderDebit,

  /// Credit restored to wallet from a cancelled order refund.
  refundCredit,
}
