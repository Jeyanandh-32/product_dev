import 'package:backend/models/stock/stock_dto.dart';
import 'package:backend/utils/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
abstract class ProductDto with _$ProductDto {
  @JsonSerializable(fieldRename: .snake)
  const factory ProductDto({
    required String id,
    required String merchantId,
    required String name,
    @JsonKey(fromJson: doubleFromJson) required double taxRate,
    required int basePrice,
    required int sellingPrice,
    required bool isActive,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime updatedAt,
    String? categoryId,
    String? counterId,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    StockDto? stock,
    String? categoryName,
    String? counterName,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, Object?> json) =>
      _$ProductDtoFromJson(json);
}
