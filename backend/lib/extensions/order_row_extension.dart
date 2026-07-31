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
    source: .values.byName(source),
    type: .values.byName(type),
    status: .values.byName(status),
    paymentStatus: .values.byName(paymentStatus),
    paymentMethod: .values.byName(paymentMethod),
    subtotal: subtotal / 100,
    taxTotal: taxTotal / 100,
    grandTotal: grandTotal / 100,
    terminalCode: terminalCode,
    items: items.map((o) => o.toOrderItem()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
