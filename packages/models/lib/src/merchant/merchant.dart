import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant.freezed.dart';
part 'merchant.g.dart';

@freezed
abstract class Merchant with _$Merchant {
  const factory Merchant({
    required String id,
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Merchant;

  factory Merchant.fromJson(Map<String, Object?> json) =>
      _$MerchantFromJson(json);
}
