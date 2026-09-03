import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/merchant/platform_fee_settlement.dart';

part 'merchant_platform_fee_summary.freezed.dart';
part 'merchant_platform_fee_summary.g.dart';

/// Summary of unsettled and settled platform fees for a merchant account.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class MerchantPlatformFeeSummary with _$MerchantPlatformFeeSummary {
  const factory MerchantPlatformFeeSummary({
    required int unsettledAmountInPaise,
    required int unsettledOrdersCount,
    @Default([]) List<PlatformFeeSettlement> recentSettlements,
  }) = _MerchantPlatformFeeSummary;

  factory MerchantPlatformFeeSummary.fromJson(Map<String, dynamic> json) =>
      _$MerchantPlatformFeeSummaryFromJson(json);
}
