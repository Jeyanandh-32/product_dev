import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_dto.freezed.dart';
part 'merchant_dto.g.dart';

@freezed
@JsonSerializable(fieldRename: .snake)
class MerchantDto with _$MerchantDto {
  MerchantDto({
    required this.id,
    required this.name,
    required this.businessName,
    required this.whatsappNumber,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchantDto.fromJson(Map<String, Object?> json) =>
      _$MerchantDtoFromJson(json);

  Map<String, Object?> toJson() => _$MerchantDtoToJson(this);

  @override
  final String id;
  @override
  final String name;
  @override
  final String businessName;
  @override
  final String whatsappNumber;
  @override
  final String email;
  @override
  final String passwordHash;
  @override
  @JsonKey(fromJson: _fromJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _fromJson)
  final DateTime updatedAt;

  static DateTime _fromJson(DateTime value) => value;
}
