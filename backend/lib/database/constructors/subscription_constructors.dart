part of '../schema.dart';

/// Constructs a [SubscriptionPlanRow] instance.
SubscriptionPlanRow constructSubscriptionPlanRow({
  required String code,
  required String name,
  required int priceInPaise,
  required String currency,
  required int durationDays,
  required String features,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$SubscriptionPlanRow._(code, name, priceInPaise, currency, durationDays, features, createdAt, updatedAt);

/// Constructs a [StoreSubscriptionRow] instance.
StoreSubscriptionRow constructStoreSubscriptionRow({
  required String id,
  required String storeId,
  required String planCode,
  required String status,
  required DateTime startsAt,
  required DateTime endsAt,
  required bool autoRenew,
  required DateTime createdAt,
  required DateTime updatedAt,
  DateTime? graceEndsAt,
}) => _$StoreSubscriptionRow._(id, storeId, planCode, status, startsAt, endsAt, graceEndsAt, autoRenew, createdAt, updatedAt);

/// Constructs a [SubscriptionTransactionRow] instance.
SubscriptionTransactionRow constructSubscriptionTransactionRow({
  required String id,
  required String storeId,
  required String planCode,
  required int amountInPaise,
  required String currency,
  required String paymentMethod,
  required String status,
  required DateTime createdAt,
  String? reference,
}) => _$SubscriptionTransactionRow._(id, storeId, planCode, amountInPaise, currency, paymentMethod, status, reference, createdAt);
