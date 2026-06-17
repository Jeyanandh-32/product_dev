import 'package:backend/utils/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@freezed
abstract class CategoryDto with _$CategoryDto {
  @JsonSerializable(fieldRename: .snake)
  const factory CategoryDto({
    required String id,
    required String name,
    required String merchantId,
    required String storeId,
    required bool isActive,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime updatedAt,
    String? description,
    String? imageUrl,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, Object?> json) =>
      _$CategoryDtoFromJson(json);
}
