import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottle_credit.freezed.dart';
part 'bottle_credit.g.dart';

/// Aggregated merchant-wide digital bottle return credit balance for a customer.
@freezed
abstract class BottleCredit with _$BottleCredit {
  const factory BottleCredit({
    required String id,
    required String merchantId,
    required String customerPhone,
    @Default(0) int balance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BottleCredit;

  factory BottleCredit.fromJson(Map<String, dynamic> json) =>
      _$BottleCreditFromJson(json);
}
