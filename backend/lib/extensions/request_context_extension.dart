import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

export 'package:backend/extensions/request_context_database_extension.dart';

class ResponseException implements Exception {
  const ResponseException(this.response);
  final Response response;
}

extension RequestContextExtension on RequestContext {
  /// Reads the query parameter for storeId and validates it.
  /// Returns a Response if storeId is invalid or missing, otherwise null.
  Response? validateStoreId() {
    final storeId = request.uri.queryParameters['storeId'];
    if (storeId == null || storeId.isEmpty) {
      return badRequest(message: 'Store ID is required.');
    }
    if (!storeId.isUUID()) {
      return badRequest(message: 'Invalid store id.');
    }
    return null;
  }

  /// Gets the validated storeId from query parameters.
  String get storeId => request.uri.queryParameters['storeId'] ?? '';

  /// Parses and validates the request body using a schema validator.
  /// Returns the parsed body Map, or throws a [ResponseException] to exit early.
  Future<Map<String, dynamic>> validateBody(
    Future<String?> Function(Map<String, dynamic>) validator,
  ) async {
    final dynamic json;
    try {
      json = await request.json();
    } catch (_) {
      throw ResponseException(invalidBody());
    }
    if (json is! Map<String, dynamic>) {
      throw ResponseException(invalidBody());
    }
    final errorMsg = await validator(json);
    if (errorMsg != null) {
      throw ResponseException(badRequest(message: errorMsg));
    }
    return json;
  }

  /// Returns the authenticated token payload from the context if present, otherwise null.
  TokenPayload? get optionalTokenPayload {
    try {
      return read<TokenPayload>();
    } catch (_) {
      return null;
    }
  }

  /// Returns the authenticated token payload from the context.
  TokenPayload get tokenPayload => read<TokenPayload>();

  /// Parses and validates the query parameter 'page'.
  /// Returns a Response if invalid, otherwise the parsed integer (defaults to 1).
  (Response?, int) parsePage() {
    final pageStr = request.uri.queryParameters['page'];
    if (pageStr == null || pageStr.isEmpty) return (null, 1);
    final page = int.tryParse(pageStr);
    if (page == null || page <= 0) {
      return (badRequest(message: 'page must be a positive integer >= 1.'), 1);
    }
    return (null, page);
  }

  /// Parses and validates the query parameter 'size'.
  /// Returns a Response if invalid, otherwise the parsed integer (defaults to 50).
  (Response?, int) parseSize({int defaultSize = 50}) {
    final sizeStr = request.uri.queryParameters['size'];
    if (sizeStr == null || sizeStr.isEmpty) return (null, defaultSize);
    final size = int.tryParse(sizeStr);
    if (size == null || size <= 0) {
      return (
        badRequest(message: 'size must be a positive integer >= 1.'),
        defaultSize,
      );
    }
    return (null, size);
  }
}
