import 'package:freezed_annotation/freezed_annotation.dart';

import '../category/category.dart';
import '../counter/counter.dart';
import '../stock/stock.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Represents a catalog product offered by a merchant.
@freezed
abstract class Product with _$Product {
  /// Creates a [Product] instance.
  const factory Product({
    required String id,
    required String merchantId,
    required String name,
    required double taxRate,
    required double basePrice,
    required double sellingPrice,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    Stock? stock,
    Category? category,
    Counter? counter,
  }) = _Product;

  /// Creates a [Product] from a JSON map.
  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);
}
