import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant.freezed.dart';
part 'merchant.g.dart';

/// Represents a registered merchant account and business profile.
@freezed
abstract class Merchant with _$Merchant {
  /// Creates a [Merchant] instance.
  const factory Merchant({
    required String id,
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Merchant;

  /// Creates a [Merchant] from a JSON map.
  factory Merchant.fromJson(Map<String, Object?> json) =>
      _$MerchantFromJson(json);
}
