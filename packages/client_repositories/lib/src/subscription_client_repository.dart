import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository handling store subscription fetching, plans, and renewals.
abstract final class SubscriptionClientRepository {
  /// Fetches all active subscription plans.
  static Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final result = await dio.get(ApiEndpoints.subscriptionPlans);
      final rawData = result.data['data'] as Map;
      final list = (rawData['plans'] as List).cast<Map>();
      return list
          .map((p) => SubscriptionPlan.fromJson(Map<String, dynamic>.from(p)))
          .toList();
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch subscription plans.');
    }
  }

  /// Fetches current subscription details, plan, and transactions for a store.
  static Future<
    ({
      StoreSubscription? subscription,
      SubscriptionPlan? plan,
      List<SubscriptionTransaction> transactions,
    })
  >
  getStoreSubscription(String storeId) async {
    try {
      final result = await dio.get(ApiEndpoints.storeSubscription(storeId));
      final rawData = result.data['data'] as Map;
      final data = Map<String, dynamic>.from(rawData);

      final rawSub = data['subscription'] as Map?;
      final subscription = rawSub != null
          ? StoreSubscription.fromJson(Map<String, dynamic>.from(rawSub))
          : null;

      final rawPlan = data['plan'] as Map?;
      final plan = rawPlan != null
          ? SubscriptionPlan.fromJson(Map<String, dynamic>.from(rawPlan))
          : null;

      final rawTxList = (data['transactions'] as List?)?.cast<Map>() ?? [];
      final transactions = rawTxList
          .map(
            (t) =>
                SubscriptionTransaction.fromJson(Map<String, dynamic>.from(t)),
          )
          .toList();

      return (
        subscription: subscription,
        plan: plan,
        transactions: transactions,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch store subscription.');
    }
  }

  /// Initiates PhonePe checkout session for store subscription.
  static Future<SubscriptionPaymentSession> initiateSubscriptionPayment({
    required String storeId,
    required SubscriptionPlanCode planCode,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.storeSubscriptionInitiatePayment(storeId),
        data: {'planCode': planCode.name},
      );
      final rawData = result.data['data'] as Map;
      final data = Map<String, dynamic>.from(rawData);
      return SubscriptionPaymentSession.fromJson(data);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to initiate subscription payment.');
    }
  }

  /// Verifies subscription payment with backend after PhonePe checkout.
  static Future<({StoreSubscription subscription, SubscriptionPlan plan})>
  verifySubscriptionPayment({
    required String storeId,
    required String merchantTransactionId,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.storeSubscriptionVerifyPayment(storeId),
        data: {'merchantTransactionId': merchantTransactionId},
      );
      final rawData = result.data['data'] as Map;
      final data = Map<String, dynamic>.from(rawData);
      return (
        subscription: StoreSubscription.fromJson(
          Map<String, dynamic>.from(data['subscription'] as Map),
        ),
        plan: SubscriptionPlan.fromJson(
          Map<String, dynamic>.from(data['plan'] as Map),
        ),
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to verify subscription payment.');
    }
  }

  /// Renews or upgrades the store subscription with the selected plan.
  static Future<({StoreSubscription subscription, SubscriptionPlan plan})>
  renewSubscription({
    required String storeId,
    required SubscriptionPlanCode planCode,
    SubscriptionPaymentMethod paymentMethod =
        SubscriptionPaymentMethod.simulated,
    String? reference,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.storeSubscriptionRenew(storeId),
        data: {
          'plan_code': planCode.name,
          'planCode': planCode.name,
          'payment_method': paymentMethod.name,
          'paymentMethod': paymentMethod.name,
          if (reference != null) 'reference': reference,
        },
      );
      final rawData = result.data['data'] as Map;
      final data = Map<String, dynamic>.from(rawData);

      return (
        subscription: StoreSubscription.fromJson(
          Map<String, dynamic>.from(data['subscription'] as Map),
        ),
        plan: SubscriptionPlan.fromJson(
          Map<String, dynamic>.from(data['plan'] as Map),
        ),
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to renew store subscription.');
    }
  }
}
