part of '../schema.dart';

/// Constructs a [ProductRow] instance.
ProductRow constructProductRow({
  required String id,
  required String merchantId,
  required String storeId,
  required String name,
  required double taxRate,
  required int basePrice,
  required int sellingPrice,
  required bool isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  String? sku,
  String? barcode,
  String? description,
  String? imageUrl,
  String? categoryId,
  String? counterId,
}) => _$ProductRow._(id, merchantId, storeId, name, sku, barcode, description, imageUrl, categoryId, counterId, taxRate, basePrice, sellingPrice, isActive, createdAt, updatedAt);

/// Constructs a [StockRow] instance.
StockRow constructStockRow({
  required String id,
  required String productId,
  required String storeId,
  required int quantity,
  required int lowStockThreshold,
  required bool stockMonitor,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => _$StockRow._(id, productId, storeId, quantity, lowStockThreshold, stockMonitor, createdAt, updatedAt);

/// Constructs a [StockTransactionRow] instance.
StockTransactionRow constructStockTransactionRow({
  required String id,
  required String productId,
  required String storeId,
  required String adjustmentType,
  required int quantity,
  required String reason,
  required DateTime createdAt,
  String? customReason,
}) => _$StockTransactionRow._(id, productId, storeId, adjustmentType, quantity, reason, customReason, createdAt);
