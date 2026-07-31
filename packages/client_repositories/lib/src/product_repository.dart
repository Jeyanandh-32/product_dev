import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';

class ProductRepository {
  const ProductRepository._();

  static Future<Product> create({
    required String storeId,
    required String name,
    required String categoryId,
    required String counterId,
    required double basePrice,
    required double sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await dio.post(
        ApiEndpoints.products,
        queryParameters: {'storeId': storeId},
        data: {
          'name': name,
          'categoryId': categoryId,
          'counterId': counterId,
          'basePrice': basePrice,
          'sellingPrice': sellingPrice,
          'taxRate': ?taxRate,
          'sku': ?sku,
          'barcode': ?barcode,
          'description': ?description,
          'imageUrl': ?imageUrl,
        },
      );

      return Product.fromJson(
        result.data['data']['product'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to create product.');
    }
  }

  static Future<Product> update({
    required String id,
    String? name,
    String? categoryId,
    String? counterId,
    bool? isActive,
    double? basePrice,
    double? sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final path = '${ApiEndpoints.products}/$id';
      final result = await dio.patch(
        path,
        data: {
          'name': ?name,
          'categoryId': ?categoryId,
          'counterId': ?counterId,
          'isActive': ?isActive,
          'basePrice': ?basePrice,
          'sellingPrice': ?sellingPrice,
          'taxRate': ?taxRate,
          'sku': ?sku,
          'barcode': ?barcode,
          'description': ?description,
          'imageUrl': ?imageUrl,
        },
      );

      return Product.fromJson(
        result.data['data']['product'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to update product.');
    }
  }

  static Future<PaginatedResponse<Product>> getAll({
    required String storeId,
    int? page,
    int? size,
  }) async {
    try {
      final result = await dio.get(
        ApiEndpoints.products,
        queryParameters: {'storeId': storeId, 'page': ?page, 'size': ?size},
      );

      return parsePaginatedResponse(
        data: result.data['data'] as Map<String, dynamic>,
        key: 'products',
        fromJson: Product.fromJson,
      );
    } on DioException catch (e) {
      handleDioError(e, 'Failed to fetch products.');
    }
  }
}
