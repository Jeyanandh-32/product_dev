import 'package:backend/utils/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_dto.freezed.dart';
part 'stock_dto.g.dart';

@freezed
abstract class StockDto with _$StockDto {
  @JsonSerializable(fieldRename: .snake)
  const factory StockDto({
    required String id,
    required String productId,
    required String storeId,
    required int quantity,
    required int lowStockThreshold,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime updatedAt,
  }) = _StockDto;

  factory StockDto.fromJson(Map<String, Object?> json) =>
      _$StockDtoFromJson(json);
}
