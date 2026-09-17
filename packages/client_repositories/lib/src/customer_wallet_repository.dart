import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// Client repository for querying wallet balance, transactions, and initiating top-ups.
class CustomerWalletRepository {
  const CustomerWalletRepository._();

  /// Fetches the customer's current wallet balance and transaction history.
  static Future<({double balance, List<CustomerWalletTransaction> transactions})>
  getWalletInfo({String? storeId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }
      final result = await dio.get(
        ApiEndpoints.customerWallet,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final data = result.data['data'] as Map<String, dynamic>;
      final balance = ((data['balance'] ?? data['walletBalance']) as num?)?.toDouble() ?? 0.0;
      final txList = data['transactions'] as List<dynamic>? ?? [];

      final transactions = txList
          .map((t) => CustomerWalletTransaction.fromJson(t as Map<String, Object?>))
          .toList();

      return (balance: balance, transactions: transactions);
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch wallet details.');
    }
  }

  /// Initiates a wallet balance top-up payment session.
  static Future<({double? balance, CustomerWalletTransaction transaction, String? tokenUrl, String? merchantOrderId, bool isPendingPayment})> topUp(
    double amount, {
    String? storeId,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.customerWallet,
        data: {
          'amount': amount,
          'storeId': ?storeId,
        },
      );
      final data = result.data['data'] as Map<String, dynamic>;
      final balance = (data['walletBalance'] as num?)?.toDouble();
      final tokenUrl = data['tokenUrl'] as String?;
      final merchantOrderId = data['merchantOrderId'] as String?;
      final isPendingPayment = data['isPendingPayment'] as bool? ?? false;
      final transaction = CustomerWalletTransaction.fromJson(
        data['transaction'] as Map<String, Object?>,
      );

      return (
        balance: balance,
        transaction: transaction,
        tokenUrl: tokenUrl,
        merchantOrderId: merchantOrderId,
        isPendingPayment: isPendingPayment,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to top up wallet balance.');
    }
  }
}
