import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository for interacting with bottle return APIs across Terminal and Customer apps.
class BottleReturnClientRepository {
  const BottleReturnClientRepository._();

  /// Checks if bottle return system is enabled for a store and gets reward amount.
  static Future<BottleReturnConfig?> getConfig(String storeId) async {
    try {
      final res = await dio.get(ApiEndpoints.bottleReturnsConfig, queryParameters: {'storeId': storeId});
      final data = res.data['data'] as Map<String, dynamic>?;
      final cfgMap = data?['config'] as Map<String, dynamic>?;
      return cfgMap == null ? null : BottleReturnConfig.fromJson(cfgMap);
    } on DioException {
      return null;
    }
  }

  /// Generates QR tokens for an order's returnable items.
  static Future<List<BottleQrToken>> generateTokens({
    required String merchantId,
    required String storeId,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required BottleRewardMode rewardMode,
    String? customerPhone,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.bottleReturnsTokens,
        data: {
          'merchantId': merchantId,
          'storeId': storeId,
          'orderId': orderId,
          'items': items,
          'rewardMode': rewardMode.name,
          'customerPhone': ?customerPhone,
        },
      );
      final list = res.data['data']['tokens'] as List<dynamic>;
      return list.map((t) => BottleQrToken.fromJson(t as Map<String, dynamic>)).toList();
    } on DioException {
      return [];
    }
  }

  /// Retrieves customer's available bottle return credit balance.
  static Future<int> getPhoneCreditBalance({required String phone, required String merchantId}) async {
    try {
      final res = await dio.get(
        ApiEndpoints.bottleReturnsCreditsBalance,
        queryParameters: {'phone': phone, 'merchantId': merchantId},
      );
      return (res.data['data']['balance'] as num?)?.toInt() ?? 0;
    } on DioException {
      return 0;
    }
  }

  /// Applies bottle return credit deduction during checkout.
  static Future<bool> applyCreditDeduction({
    required String merchantId,
    required String customerPhone,
    required int amount,
    required String storeId,
    String? orderId,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.bottleReturnsCreditsApply,
        data: {
          'merchantId': merchantId,
          'customerPhone': customerPhone,
          'amount': amount,
          'storeId': storeId,
          'orderId': ?orderId,
        },
      );
      return res.data['data']['success'] as bool? ?? false;
    } on DioException {
      return false;
    }
  }

  /// Validates a physical paper coupon voucher without throwing uncaught exceptions.
  static Future<BottlePhysicalCoupon?> validatePhysicalCoupon({
    required String merchantId,
    required String code,
    required String storeId,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.bottleReturnsCouponsValidate,
        data: {'merchantId': merchantId, 'code': code, 'storeId': storeId},
      );
      final couponMap = res.data['data']['coupon'] as Map<String, dynamic>;
      return BottlePhysicalCoupon.fromJson(couponMap);
    } on DioException {
      return null;
    }
  }

  /// Marks a physical paper coupon voucher as redeemed upon order checkout.
  static Future<bool> redeemPhysicalCoupon({
    required String merchantId,
    required String code,
    required String storeId,
    required String orderId,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.bottleReturnsCouponsRedeem,
        data: {'merchantId': merchantId, 'code': code, 'storeId': storeId, 'orderId': orderId},
      );
      return res.data['data']['success'] as bool? ?? false;
    } on DioException {
      return false;
    }
  }
}
