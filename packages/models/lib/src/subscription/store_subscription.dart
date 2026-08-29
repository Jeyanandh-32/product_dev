import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/subscription/subscription_plan_code.dart';
import 'package:models/src/subscription/subscription_status.dart';

part 'store_subscription.freezed.dart';
part 'store_subscription.g.dart';

/// Per-store subscription state and validity timestamps.
@freezed
abstract class StoreSubscription with _$StoreSubscription {
  const factory StoreSubscription({
    required String id,
    required String storeId,
    required SubscriptionPlanCode planCode,
    required SubscriptionStatus status,
    required DateTime startsAt,
    required DateTime endsAt,
    DateTime? graceEndsAt,
    @Default(true) bool autoRenew,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StoreSubscription;

  factory StoreSubscription.fromJson(Map<String, dynamic> json) =>
      _$StoreSubscriptionFromJson(json);
}
