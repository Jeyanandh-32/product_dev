import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant.freezed.dart';
part 'merchant.g.dart';

@freezed
@JsonSerializable()
class Merchant with _$Merchant {
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
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  Merchant({
    required this.id,
    required this.name,
    required this.businessName,
    required this.whatsappNumber,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, Object?> toJson() => _$MerchantToJson(this);

  factory Merchant.fromJson(Map<String, Object?> json) =>
      _$MerchantFromJson(json);
}
