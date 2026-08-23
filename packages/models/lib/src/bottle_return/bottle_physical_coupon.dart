import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottle_physical_coupon.freezed.dart';
part 'bottle_physical_coupon.g.dart';

/// Single-use paper voucher printed by the reverse vending machine or issued at POS.
@freezed
abstract class BottlePhysicalCoupon with _$BottlePhysicalCoupon {
  const factory BottlePhysicalCoupon({
    required String id,
    required String code,
    required String merchantId,
    required String storeId,
    required int amount,
    @Default('active') String status,
    DateTime? redeemedAt,
    String? redeemedOrderId,
    DateTime? createdAt,
  }) = _BottlePhysicalCoupon;

  factory BottlePhysicalCoupon.fromJson(Map<String, dynamic> json) =>
      _$BottlePhysicalCouponFromJson(json);
}
