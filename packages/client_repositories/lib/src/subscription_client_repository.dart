import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository handling store subscription fetching, plans, and renewals.
abstract final class SubscriptionClientRepository {
  /// Fetches all active subscription plans.
  static Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final result = await dio.get(ApiEndpoints.subscriptionPlans);
      final list = result.data['data']['plans'] as List<dynamic>;
      return list
          .map((p) => SubscriptionPlan.fromJson(p as Map<String, Object?>))
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
      final data = result.data['data'] as Map<String, dynamic>;

      final rawSub = data['subscription'];
      final subscription = rawSub != null
          ? StoreSubscription.fromJson(rawSub as Map<String, Object?>)
          : null;

      final rawPlan = data['plan'];
      final plan = rawPlan != null
          ? SubscriptionPlan.fromJson(rawPlan as Map<String, Object?>)
          : null;

      final rawTxList = data['transactions'] as List<dynamic>? ?? [];
      final transactions = rawTxList
          .map(
            (t) => SubscriptionTransaction.fromJson(t as Map<String, Object?>),
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
      final data = result.data['data'] as Map<String, dynamic>;

      final subscription = StoreSubscription.fromJson(
        data['subscription'] as Map<String, Object?>,
      );
      final plan = SubscriptionPlan.fromJson(
        data['plan'] as Map<String, Object?>,
      );

      return (subscription: subscription, plan: plan);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to renew store subscription.');
    }
  }
}
