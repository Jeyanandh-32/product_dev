import 'package:freezed_annotation/freezed_annotation.dart';
import '../stock/stock.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String merchantId,
    required String name,
    required double taxRate,
    required int basePrice,
    required int sellingPrice,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? categoryId,
    String? counterId,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    Stock? stock,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);
}
