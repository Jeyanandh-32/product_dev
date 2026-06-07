import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_dto.g.dart';
part 'store_dto.freezed.dart';

@freezed
abstract class StoreDto with _$StoreDto {
  @JsonSerializable(fieldRename: .snake)
  const factory StoreDto({
    required String id,
    required String merchantId,
    required String name,
    @JsonKey(fromJson: _fromJson) required DateTime createdAt,
    @JsonKey(fromJson: _fromJson) required DateTime updatedAt,
    String? storeType,
  }) = _StoreDto;

  factory StoreDto.fromJson(Map<String, Object?> json) =>
      _$StoreDtoFromJson(json);
}

DateTime _fromJson(DateTime value) => value;
