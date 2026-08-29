import 'package:backend/database/schema.dart';

/// Test factory for [BottleReturnConfigRow].
BottleReturnConfigRow createBottleReturnConfigRow({
  String storeId = 'store-1',
  bool isEnabled = true,
  int rewardAmountInRupees = 5,
  String? iotApiKey,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructBottleReturnConfigRow(
    storeId: storeId,
    isEnabled: isEnabled,
    rewardAmountInRupees: rewardAmountInRupees,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    iotApiKey: iotApiKey,
  );
}

/// Test factory for [BottleReturnProductRow].
BottleReturnProductRow createBottleReturnProductRow({
  String productId = 'prod-1',
  String storeId = 'store-1',
  bool isReturnable = true,
  DateTime? createdAt,
}) {
  return constructBottleReturnProductRow(
    productId: productId,
    storeId: storeId,
    isReturnable: isReturnable,
    createdAt: createdAt ?? DateTime.now(),
  );
}

/// Test factory for [BottleQrTokenRow].
BottleQrTokenRow createBottleQrTokenRow({
  String id = 'token-1',
  String token = 'QR123456',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  String orderId = 'order-1',
  String productId = 'prod-1',
  String rewardMode = 'credits',
  String? customerPhone,
  String status = 'active',
  DateTime? returnedAt,
  String? returnedStoreId,
  DateTime? createdAt,
}) {
  return constructBottleQrTokenRow(
    id: id,
    token: token,
    merchantId: merchantId,
    storeId: storeId,
    orderId: orderId,
    productId: productId,
    rewardMode: rewardMode,
    status: status,
    createdAt: createdAt ?? DateTime.now(),
    customerPhone: customerPhone,
    returnedAt: returnedAt,
    returnedStoreId: returnedStoreId,
  );
}

/// Test factory for [BottleCreditRow].
BottleCreditRow createBottleCreditRow({
  String id = 'credit-1',
  String merchantId = 'm-1',
  String customerPhone = '9876543210',
  int balance = 500,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructBottleCreditRow(
    id: id,
    merchantId: merchantId,
    customerPhone: customerPhone,
    balance: balance,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

/// Test factory for [BottleCreditTransactionRow].
BottleCreditTransactionRow createBottleCreditTransactionRow({
  String id = 'btx-1',
  String merchantId = 'm-1',
  String customerPhone = '9876543210',
  int amount = 500,
  String type = 'earned',
  String? referenceOrderId,
  String? storeId,
  DateTime? createdAt,
}) {
  return constructBottleCreditTransactionRow(
    id: id,
    merchantId: merchantId,
    customerPhone: customerPhone,
    amount: amount,
    type: type,
    createdAt: createdAt ?? DateTime.now(),
    referenceOrderId: referenceOrderId,
    storeId: storeId,
  );
}

/// Test factory for [BottlePhysicalCouponRow].
BottlePhysicalCouponRow createBottlePhysicalCouponRow({
  String id = 'coupon-1',
  String code = 'COUPON01',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  int amount = 500,
  String status = 'active',
  DateTime? redeemedAt,
  String? redeemedOrderId,
  DateTime? createdAt,
}) {
  return constructBottlePhysicalCouponRow(
    id: id,
    code: code,
    merchantId: merchantId,
    storeId: storeId,
    amount: amount,
    status: status,
    createdAt: createdAt ?? DateTime.now(),
    redeemedAt: redeemedAt,
    redeemedOrderId: redeemedOrderId,
  );
}
