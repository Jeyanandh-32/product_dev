import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

abstract final class PaymentRepository {
  static Future<PaginatedResponse<Payment>> getAll({
    required String storeId,
    int? page,
    int? size,
    String? fromDate,
    String? toDate,
    String? paymentMethod,
    String? paymentStatus,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.payments,
        queryParameters: {
          'storeId': storeId,
          'page': ?page,
          'size': ?size,
          'fromDate': ?fromDate,
          'toDate': ?toDate,
          'paymentMethod': ?paymentMethod,
          'paymentStatus': ?paymentStatus,
        },
      );

      return parsePaginatedResponse(
        data: result.data['data'] as Map<String, dynamic>,
        key: 'payments',
        fromJson: Payment.fromJson,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch payments.');
    }
  }
}
