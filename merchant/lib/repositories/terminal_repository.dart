import 'package:dio/dio.dart';
import 'package:merchant/config/api_client.dart';
import 'package:models/models.dart';

class TerminalRepository {
  const TerminalRepository._();

  static Future<List<Terminal>> getAll({String? storeId}) async {
    try {
      final result = await ApiClient.dio.get(
        ApiEndpoints.terminals,
        queryParameters: {
          'storeId': ?storeId,
        },
      );

      final list = result.data['data']['terminals'] as List<dynamic>;

      return list
          .map((t) => Terminal.fromJson(t as Map<String, Object?>))
          .toList();
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to fetch terminals.');
    }
  }

  static Future<Terminal> create({
    required String storeId,
    required String name,
    required String password,
  }) async {
    try {
      final result = await ApiClient.dio.post(
        ApiEndpoints.terminals,
        queryParameters: {'storeId': storeId},
        data: {
          'name': name,
          'password': password,
        },
      );

      return Terminal.fromJson(
        result.data['data']['terminal'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to create terminal.');
    }
  }

  static Future<Terminal> update({
    required String code,
    String? name,
    String? password,
    bool? isActive,
  }) async {
    try {
      final path = '${ApiEndpoints.terminals}/$code';
      final result = await ApiClient.dio.patch(
        path,
        data: {
          'name': ?name,
          'password': ?password,
          'isActive': ?isActive,
        },
      );

      return Terminal.fromJson(
        result.data['data']['terminal'] as Map<String, Object?>,
      );
    } on DioException catch (e) {
      ApiClient.handleDioError(e, 'Failed to update terminal.');
    }
  }
}
