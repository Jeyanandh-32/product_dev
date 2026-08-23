import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

/// Extension methods to convert bottle return database rows to domain models.
extension BottleReturnConfigRowExtension on BottleReturnConfigRow {
  /// Converts [BottleReturnConfigRow] to [BottleReturnConfig].
  BottleReturnConfig toModel() => BottleReturnConfig(
    storeId: storeId,
    isEnabled: isEnabled,
    rewardAmountInRupees: rewardAmountInRupees,
    iotApiKey: iotApiKey,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension BottleQrTokenRowExtension on BottleQrTokenRow {
  /// Converts [BottleQrTokenRow] to [BottleQrToken].
  BottleQrToken toModel() => BottleQrToken(
    id: id,
    token: token,
    merchantId: merchantId,
    storeId: storeId,
    orderId: orderId,
    productId: productId,
    rewardMode: BottleRewardMode.fromString(rewardMode),
    customerPhone: customerPhone,
    status: BottleTokenStatus.fromString(status),
    returnedAt: returnedAt,
    returnedStoreId: returnedStoreId,
    createdAt: createdAt,
  );
}

extension BottleCreditRowExtension on BottleCreditRow {
  /// Converts [BottleCreditRow] to [BottleCredit].
  BottleCredit toModel() => BottleCredit(
    id: id,
    merchantId: merchantId,
    customerPhone: customerPhone,
    balance: balance,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension BottleCreditTransactionRowExtension on BottleCreditTransactionRow {
  /// Converts [BottleCreditTransactionRow] to [BottleCreditTransaction].
  BottleCreditTransaction toModel() => BottleCreditTransaction(
    id: id,
    merchantId: merchantId,
    customerPhone: customerPhone,
    amount: amount,
    type: type,
    referenceOrderId: referenceOrderId,
    storeId: storeId,
    createdAt: createdAt,
  );
}

extension BottlePhysicalCouponRowExtension on BottlePhysicalCouponRow {
  /// Converts [BottlePhysicalCouponRow] to [BottlePhysicalCoupon].
  BottlePhysicalCoupon toModel() => BottlePhysicalCoupon(
    id: id,
    code: code,
    merchantId: merchantId,
    storeId: storeId,
    amount: amount,
    status: status,
    redeemedAt: redeemedAt,
    redeemedOrderId: redeemedOrderId,
    createdAt: createdAt,
  );
}
