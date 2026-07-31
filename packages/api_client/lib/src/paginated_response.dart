/// A generic record type for paginated API responses.
typedef PaginatedResponse<T> = ({
  List<T> items,
  int currentPage,
  int pageSize,
  int totalItems,
  int totalPages,
});

/// Parses a paginated JSON response into a [PaginatedResponse].
///
/// [data] is the `result.data['data']` map from the API response.
/// [key] is the JSON key for the list of items (e.g. 'products', 'categories').
/// [fromJson] converts a single JSON map into a model instance.
PaginatedResponse<T> parsePaginatedResponse<T>({
  required Map<String, dynamic> data,
  required String key,
  required T Function(Map<String, Object?>) fromJson,
}) {
  final list = data[key] as List<dynamic>;
  final currentPage = data['currentPage'] as int? ?? 1;
  final pageSize = data['pageSize'] as int? ?? 50;
  final totalItems = data['totalItems'] as int? ?? list.length;
  final totalPages = data['totalPages'] as int? ?? 1;

  final items = list.map((e) => fromJson(e as Map<String, Object?>)).toList();

  return (
    items: items,
    currentPage: currentPage,
    pageSize: pageSize,
    totalItems: totalItems,
    totalPages: totalPages,
  );
}
