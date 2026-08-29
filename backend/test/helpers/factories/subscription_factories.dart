import 'package:backend/database/schema.dart';

/// Test factory for [SubscriptionPlanRow].
SubscriptionPlanRow createSubscriptionPlanRow({
  String code = 'trial',
  String name = '14-Day Free Trial',
  int priceInPaise = 0,
  String currency = 'INR',
  int durationDays = 14,
  String features = '[]',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructSubscriptionPlanRow(
    code: code,
    name: name,
    priceInPaise: priceInPaise,
    currency: currency,
    durationDays: durationDays,
    features: features,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

/// Test factory for [StoreSubscriptionRow].
StoreSubscriptionRow createStoreSubscriptionRow({
  String id = 'sub-1',
  String storeId = 'store-1',
  String planCode = 'trial',
  String status = 'trial',
  DateTime? startsAt,
  DateTime? endsAt,
  DateTime? graceEndsAt,
  bool autoRenew = true,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructStoreSubscriptionRow(
    id: id,
    storeId: storeId,
    planCode: planCode,
    status: status,
    startsAt: startsAt ?? now,
    endsAt: endsAt ?? now.add(const Duration(days: 30)),
    autoRenew: autoRenew,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    graceEndsAt: graceEndsAt,
  );
}

/// Test factory for [SubscriptionTransactionRow].
SubscriptionTransactionRow createSubscriptionTransactionRow({
  String id = 'stx-1',
  String storeId = 'store-1',
  String planCode = 'trial',
  int amountInPaise = 0,
  String currency = 'INR',
  String paymentMethod = 'simulated',
  String status = 'completed',
  String? reference,
  DateTime? createdAt,
}) {
  return constructSubscriptionTransactionRow(
    id: id,
    storeId: storeId,
    planCode: planCode,
    amountInPaise: amountInPaise,
    currency: currency,
    paymentMethod: paymentMethod,
    status: status,
    createdAt: createdAt ?? DateTime.now(),
    reference: reference,
  );
}
