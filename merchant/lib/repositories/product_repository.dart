import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class ProductRepository {
  const ProductRepository._();

  static Future<Product> create({
    required String storeId,
    required String name,
    required String categoryId,
    required String counterId,
    required int basePrice,
    required int sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.products,
        queryParameters: {'storeId': storeId},
        data: {
          'name': name,
          'categoryId': categoryId,
          'counterId': counterId,
          'basePrice': basePrice,
          'sellingPrice': sellingPrice,
          if (taxRate != null) 'taxRate': taxRate,
          if (sku != null) 'sku': sku,
          if (barcode != null) 'barcode': barcode,
          if (description != null) 'description': description,
          if (imageUrl != null) 'imageUrl': imageUrl,
        },
      );

      return Product.fromJson(
        result.data['data']['product'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to create product.');
    }
  }

  static Future<Product> update({
    required String id,
    String? name,
    String? categoryId,
    String? counterId,
    bool? isActive,
    int? basePrice,
    int? sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final path = '${ApiEndpoints.products}/$id';
      final result = await ApiClient.dio.patch(
        path,
        data: {
          if (name != null) 'name': name,
          if (categoryId != null) 'categoryId': categoryId,
          if (counterId != null) 'counterId': counterId,
          if (isActive != null) 'isActive': isActive,
          if (basePrice != null) 'basePrice': basePrice,
          if (sellingPrice != null) 'sellingPrice': sellingPrice,
          if (taxRate != null) 'taxRate': taxRate,
          if (sku != null) 'sku': sku,
          if (barcode != null) 'barcode': barcode,
          if (description != null) 'description': description,
          if (imageUrl != null) 'imageUrl': imageUrl,
        },
      );

      return Product.fromJson(
        result.data['data']['product'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to update product.');
    }
  }

  static Future<List<Product>> getAll({required String storeId}) async {
    try {
      final result = await ApiClient.dio.get(
        ApiEndpoints.products,
        queryParameters: {
          'storeId': storeId,
        },
      );

      final list = result.data['data']['products'] as List<dynamic>;

      return list
          .map((s) => Product.fromJson(s as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to fetch products.');
    }
  }
}
