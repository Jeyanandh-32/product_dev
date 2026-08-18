import 'package:backend/database/schema.dart';
import 'package:backend/extensions/customer_row_extension.dart';
import 'package:backend/extensions/order_item_row_extension.dart';
import 'package:models/models.dart';

extension OrderRowExtension on OrderRow {
  Order toOrder(
    List<OrderItemRow> items, {
    Map<String, ProductRow>? productRows,
    CustomerRow? customerRow,
  }) => Order(
    id: id,
    merchantId: merchantId,
    storeId: storeId,
    orderReference: orderReference,
    billNo: billNo,
    source: OrderSource.values.firstWhere(
      (e) => e.name == source,
      orElse: () => OrderSource.terminal,
    ),
    type: OrderType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => OrderType.dineIn,
    ),
    status: OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderStatus.completed,
    ),
    paymentStatus: PaymentStatus.values.firstWhere(
      (e) => e.name == paymentStatus,
      orElse: () => PaymentStatus.pending,
    ),
    paymentMethod: PaymentMethod.values.firstWhere(
      (e) => e.name == paymentMethod,
      orElse: () => PaymentMethod.cash,
    ),
    subtotal: subtotal / 100,
    discountTotal: discountTotal / 100,
    walletDeduction: walletDeduction / 100,
    taxTotal: taxTotal / 100,
    grandTotal: grandTotal / 100,
    terminalCode: terminalCode,
    customer: customerRow?.toCustomer(),
    items: items
        .map((o) => o.toOrderItem(productRow: productRows?[o.productId]))
        .toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
