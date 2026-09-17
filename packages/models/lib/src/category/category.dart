import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Represents a product category within a store.
@freezed
abstract class Category with _$Category {
  /// Creates a [Category] instance.
  const factory Category({
    required String id,
    required String name,
    required String merchantId,
    required String storeId,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    String? imageUrl,
  }) = _Category;

  /// Creates a [Category] from a JSON map.
  factory Category.fromJson(Map<String, Object?> json) =>
      _$CategoryFromJson(json);
}
