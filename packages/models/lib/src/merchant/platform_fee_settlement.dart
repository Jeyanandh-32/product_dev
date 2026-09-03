import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform_fee_settlement.freezed.dart';
part 'platform_fee_settlement.g.dart';

/// Settlement transaction record for merchant platform fee remittances.
@freezed
abstract class PlatformFeeSettlement with _$PlatformFeeSettlement {
  const factory PlatformFeeSettlement({
    required String id,
    required String merchantId,
    required int amountInPaise,
    @Default(0) int ordersCount,
    @Default('phonepe') String paymentGateway,
    String? paymentTransactionId,
    @Default('pending') String status,
    DateTime? createdAt,
    DateTime? settledAt,
  }) = _PlatformFeeSettlement;

  factory PlatformFeeSettlement.fromJson(Map<String, dynamic> json) =>
      _$PlatformFeeSettlementFromJson(json);
}
