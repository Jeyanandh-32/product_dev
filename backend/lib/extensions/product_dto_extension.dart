import 'package:backend/extensions/category_dto_extension.dart';
import 'package:backend/extensions/counter_dto_extension.dart';
import 'package:backend/extensions/stock_dto_extension.dart';
import 'package:backend/models/product/product_dto.dart';
import 'package:models/models.dart';

extension ProductDtoExtension on ProductDto {
  Product toProduct() => Product(
    id: id,
    merchantId: merchantId,
    name: name,
    taxRate: taxRate,
    basePrice: basePrice,
    sellingPrice: sellingPrice,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
    sku: sku,
    barcode: barcode,
    description: description,
    imageUrl: imageUrl,
    stock: stock?.toStock(),
    category: category?.toCategory(),
    counter: counter?.toCounter(),
  );
}
