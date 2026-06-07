import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_dto.freezed.dart';
part 'merchant_dto.g.dart';

@freezed
abstract class MerchantDto with _$MerchantDto {
  @JsonSerializable(fieldRename: .snake)
  const factory MerchantDto({
    required String id,
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required String passwordHash,
    @JsonKey(fromJson: _fromJson) required DateTime createdAt,
    @JsonKey(fromJson: _fromJson) required DateTime updatedAt,
  }) = _MerchantDto;

  factory MerchantDto.fromJson(Map<String, Object?> json) =>
      _$MerchantDtoFromJson(json);

  static DateTime _fromJson(DateTime value) => value;
}
