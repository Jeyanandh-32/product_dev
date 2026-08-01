import 'package:backend/database/schema.dart';
import 'package:backend/extensions/product_row_extension.dart';
import 'package:models/models.dart';

extension OrderItemRowExtension on OrderItemRow {
  OrderItem toOrderItem({ProductRow? productRow}) => OrderItem(
    id: id,
    productId: productId,
    storeId: storeId,
    quantity: quantity,
    unitPrice: unitPrice / 100,
    discount: discount / 100,
    taxRate: taxRate,
    product: productRow?.toProduct(),
  );
}
