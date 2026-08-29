import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/src/subscription/subscription_plan_code.dart';

part 'subscription_plan.freezed.dart';
part 'subscription_plan.g.dart';

/// Available subscription plan tiers for stores.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required SubscriptionPlanCode code,
    required String name,
    required int priceInPaise,
    @Default('INR') String currency,
    @Default(30) int durationDays,
    @Default([]) List<String> features,
  }) = _SubscriptionPlan;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);
}
