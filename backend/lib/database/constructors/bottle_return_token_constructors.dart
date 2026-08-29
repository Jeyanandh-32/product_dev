part of '../schema.dart';

/// Constructs a [BottleQrTokenRow] instance.
BottleQrTokenRow constructBottleQrTokenRow({
  required String id,
  required String token,
  required String merchantId,
  required String storeId,
  required String orderId,
  required String productId,
  required String rewardMode,
  required String status,
  required DateTime createdAt,
  String? customerPhone,
  DateTime? returnedAt,
  String? returnedStoreId,
}) => _$BottleQrTokenRow._(id, token, merchantId, storeId, orderId, productId, rewardMode, customerPhone, status, returnedAt, returnedStoreId, createdAt);

/// Constructs a [BottleCreditRow] instance.
BottleCreditRow constructBottleCreditRow({
  required String id,
  required String merchantId,
  required String customerPhone,
  required int balance,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$BottleCreditRow._(id, merchantId, customerPhone, balance, createdAt, updatedAt);

/// Constructs a [BottleCreditTransactionRow] instance.
BottleCreditTransactionRow constructBottleCreditTransactionRow({
  required String id,
  required String merchantId,
  required String customerPhone,
  required int amount,
  required String type,
  required DateTime createdAt,
  String? referenceOrderId,
  String? storeId,
}) => _$BottleCreditTransactionRow._(id, merchantId, customerPhone, amount, type, referenceOrderId, storeId, createdAt);

/// Constructs a [BottlePhysicalCouponRow] instance.
BottlePhysicalCouponRow constructBottlePhysicalCouponRow({
  required String id,
  required String code,
  required String merchantId,
  required String storeId,
  required int amount,
  required String status,
  required DateTime createdAt,
  DateTime? redeemedAt,
  String? redeemedOrderId,
}) => _$BottlePhysicalCouponRow._(id, code, merchantId, storeId, amount, status, redeemedAt, redeemedOrderId, createdAt);
