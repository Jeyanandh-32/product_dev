import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';

/// Client repository for fetching and toggling store returnable products.
class BottleReturnProductClientRepository {
  const BottleReturnProductClientRepository._();

  /// Lists all products for a store with their returnable bottle status.
  static Future<List<Map<String, dynamic>>> getProductsForStore(
    String storeId,
  ) async {
    try {
      final res = await dio.get(
        ApiEndpoints.bottleReturnsProducts,
        queryParameters: {'storeId': storeId},
      );
      final list = (res.data['data'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();
      return list ?? [];
    } on DioException {
      return [];
    }
  }

  /// Toggles returnable status for a product.
  static Future<bool> setProductReturnable({
    required String storeId,
    required String productId,
    required bool isReturnable,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.bottleReturnsProducts,
        data: {
          'storeId': storeId,
          'productId': productId,
          'isReturnable': isReturnable,
        },
      );
      return res.data['success'] as bool? ?? false;
    } on DioException {
      return false;
    }
  }

  /// Updates returnable status for multiple products in bulk.
  static Future<bool> bulkSetProductsReturnable({
    required String storeId,
    required List<String> productIds,
    required bool isReturnable,
  }) async {
    try {
      final res = await dio.post(
        ApiEndpoints.bottleReturnsProducts,
        data: {
          'storeId': storeId,
          'productIds': productIds,
          'isReturnable': isReturnable,
        },
      );
      return res.data['success'] as bool? ?? false;
    } on DioException {
      return false;
    }
  }
}
