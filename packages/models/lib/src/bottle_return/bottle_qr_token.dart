import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/bottle_return/bottle_reward_mode.dart';
import 'package:models/src/bottle_return/bottle_token_status.dart';

part 'bottle_qr_token.freezed.dart';
part 'bottle_qr_token.g.dart';

/// Unique QR code token generated per returnable bottle unit.
@freezed
abstract class BottleQrToken with _$BottleQrToken {
  const factory BottleQrToken({
    required String id,
    required String token,
    required String merchantId,
    required String storeId,
    required String orderId,
    required String productId,
    @Default(BottleRewardMode.digital) BottleRewardMode rewardMode,
    String? customerPhone,
    @Default(BottleTokenStatus.active) BottleTokenStatus status,
    DateTime? returnedAt,
    String? returnedStoreId,
    DateTime? createdAt,
  }) = _BottleQrToken;

  factory BottleQrToken.fromJson(Map<String, dynamic> json) =>
      _$BottleQrTokenFromJson(json);
}
