import 'dart:math';

typedef CalculatedOrderItem = ({
  String productId,
  int quantity,
  int unitPrice,
  int discount,
  double taxRate,
});

typedef CalculatedOrderSummary = ({
  int subtotal,
  int taxTotal,
  int grandTotal,
  int discountTotal,
  List<CalculatedOrderItem> items,
});

class OrderCalculator {
  const OrderCalculator._();

  /// Calculates line item price, tax, and order totals with zero complex tricks.
  static CalculatedOrderSummary calculate({
    required List<({String productId, int quantity, int sellingPrice, double taxRate, double discount})> lineItems,
    double discountTotalInput = 0.0,
    bool isComplimentary = false,
  }) {
    var subtotal = 0;
    var taxTotal = 0;
    final items = <CalculatedOrderItem>[];

    for (final item in lineItems) {
      final itemDiscountPaise = (item.discount * 100).round();
      final itemSubtotalPaise = item.sellingPrice * item.quantity;
      final taxRateDecimal = item.taxRate / 100.0;
      final taxableAmountPaise = max(0, itemSubtotalPaise - itemDiscountPaise);
      final itemTaxPaise = (taxableAmountPaise * taxRateDecimal).round();

      subtotal += itemSubtotalPaise;
      taxTotal += itemTaxPaise;

      items.add((
        productId: item.productId,
        quantity: item.quantity,
        unitPrice: item.sellingPrice,
        discount: itemDiscountPaise,
        taxRate: item.taxRate,
      ));
    }

    final overallDiscountPaise = (discountTotalInput * 100).round();
    final discountTotal = isComplimentary
        ? (subtotal + taxTotal)
        : overallDiscountPaise;

    final grandTotal = max(0, subtotal + taxTotal - discountTotal);

    return (
      subtotal: subtotal,
      taxTotal: taxTotal,
      grandTotal: grandTotal,
      discountTotal: discountTotal,
      items: items,
    );
  }
}
