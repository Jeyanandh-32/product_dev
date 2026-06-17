import 'package:backend/utils/converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminal_dto.g.dart';
part 'terminal_dto.freezed.dart';

@freezed
abstract class TerminalDto with _$TerminalDto {
  @JsonSerializable(fieldRename: .snake)
  const factory TerminalDto({
    required String code,
    required String merchantId,
    required String storeId,
    required String name,
    required String passwordHash,
    required bool isActive,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: dateTimeFromJson) required DateTime updatedAt,
  }) = _TerminalDto;

  factory TerminalDto.fromJson(Map<String, Object?> json) => _$TerminalDtoFromJson(json);
}
