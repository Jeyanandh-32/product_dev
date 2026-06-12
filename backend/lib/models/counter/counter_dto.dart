import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_dto.freezed.dart';
part 'counter_dto.g.dart';

@freezed
abstract class CounterDto with _$CounterDto {
  @JsonSerializable(fieldRename: .snake)
  const factory CounterDto({
    required String id,
    required String name,
    required String merchantId,
    required String storeId,
    required bool isActive,
    @JsonKey(fromJson: _fromJson) required DateTime createdAt,
    @JsonKey(fromJson: _fromJson) required DateTime updatedAt,
    String? description,
    String? imageUrl,
  }) = _CounterDto;

  factory CounterDto.fromJson(Map<String, Object?> json) =>
      _$CounterDtoFromJson(json);
}

DateTime _fromJson(DateTime value) => value;
