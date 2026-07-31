import 'package:backend/database/schema.dart';
import 'package:backend/extensions/category_row_extension.dart';
import 'package:backend/extensions/counter_row_extension.dart';
import 'package:backend/extensions/stock_row_extension.dart';
import 'package:models/models.dart';

extension ProductRowExtension on ProductRow {
  Product toProduct({
    StockRow? stockRow,
    CategoryRow? categoryRow,
    CounterRow? counterRow,
  }) => Product(
    id: id,
    merchantId: merchantId,
    name: name,
    taxRate: taxRate,
    basePrice: basePrice / 100.0,
    sellingPrice: sellingPrice / 100.0,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
    sku: sku,
    barcode: barcode,
    description: description,
    imageUrl: imageUrl,
    stock: stockRow?.toStock(),
    category: categoryRow?.toCategory(),
    counter: counterRow?.toCounter(),
  );
}

extension ProductRecordExtension
    on (ProductRow, StockRow?, CategoryRow?, CounterRow?) {
  Product toProduct() => $1.toProduct(
    stockRow: $2,
    categoryRow: $3,
    counterRow: $4,
  );
}
