import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/bottle_return/bottle_physical_coupon.dart';
import 'package:models/src/bottle_return/bottle_reward_mode.dart';

part 'bottle_return_session_result.freezed.dart';
part 'bottle_return_session_result.g.dart';

/// Consolidated summary returned after completing a bottle return batch.
@freezed
abstract class BottleReturnSessionResult with _$BottleReturnSessionResult {
  const factory BottleReturnSessionResult({
    required int totalBottlesReturned,
    required int totalRewardAmount,
    required BottleRewardMode rewardMode,
    String? customerPhone,
    BottlePhysicalCoupon? physicalCoupon,
    required String message,
  }) = _BottleReturnSessionResult;

  factory BottleReturnSessionResult.fromJson(Map<String, dynamic> json) =>
      _$BottleReturnSessionResultFromJson(json);
}
