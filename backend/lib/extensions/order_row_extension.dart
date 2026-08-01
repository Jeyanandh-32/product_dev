import 'package:backend/database/schema.dart';
import 'package:backend/extensions/order_item_row_extension.dart';
import 'package:models/models.dart';

extension OrderRowExtension on OrderRow {
  Order toOrder(List<OrderItemRow> items) => Order(
    id: id,
    merchantId: merchantId,
    storeId: storeId,
    orderReference: orderReference,
    billNo: billNo,
    source: OrderSource.values.firstWhere(
      (e) => e.name == source,
      orElse: () => .terminal,
    ),
    type: OrderType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => .dineIn,
    ),
    status: OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => .completed,
    ),
    paymentStatus: PaymentStatus.values.firstWhere(
      (e) => e.name == paymentStatus,
      orElse: () => .paid,
    ),
    paymentMethod: PaymentMethod.values.firstWhere(
      (e) => e.name == paymentMethod,
      orElse: () => .cash,
    ),
    subtotal: subtotal / 100,
    discountTotal: discountTotal / 100,
    taxTotal: taxTotal / 100,
    grandTotal: grandTotal / 100,
    terminalCode: terminalCode,
    items: items.map((o) => o.toOrderItem()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
