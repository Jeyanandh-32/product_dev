part of '../schema.dart';

/// Constructs a [CategoryRow] instance.
CategoryRow constructCategoryRow({
  required String id,
  required String name,
  required String merchantId,
  required String storeId,
  required bool isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  String? description,
  String? imageUrl,
}) => _$CategoryRow._(id, name, merchantId, storeId, isActive, description, imageUrl, createdAt, updatedAt);

/// Constructs a [CounterRow] instance.
CounterRow constructCounterRow({
  required String id,
  required String name,
  required String merchantId,
  required String storeId,
  required bool isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  String? description,
  String? imageUrl,
}) => _$CounterRow._(id, name, merchantId, storeId, isActive, description, imageUrl, createdAt, updatedAt);
