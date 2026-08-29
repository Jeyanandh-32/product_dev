import 'package:backend/database/schema.dart';

/// Test factory for [CategoryRow].
CategoryRow createCategoryRow({
  String id = 'cat-1',
  String name = 'Beverages',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  bool isActive = true,
  String? description,
  String? imageUrl,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructCategoryRow(
    id: id,
    name: name,
    merchantId: merchantId,
    storeId: storeId,
    isActive: isActive,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    description: description,
    imageUrl: imageUrl,
  );
}

/// Test factory for [CounterRow].
CounterRow createCounterRow({
  String id = 'counter-1',
  String name = 'Main Counter',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  bool isActive = true,
  String? description,
  String? imageUrl,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructCounterRow(
    id: id,
    name: name,
    merchantId: merchantId,
    storeId: storeId,
    isActive: isActive,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    description: description,
    imageUrl: imageUrl,
  );
}

/// Test factory for [ProductRow].
ProductRow createProductRow({
  String id = 'p-1',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  String name = 'Cold Coffee',
  String? sku = 'SKU123',
  String? barcode = 'BAR123',
  String? description = 'Fresh brew',
  String? imageUrl,
  String categoryId = 'cat-1',
  String counterId = 'counter-1',
  double taxRate = 5.0,
  int basePrice = 2000,
  int sellingPrice = 5000,
  bool isActive = true,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructProductRow(
    id: id,
    merchantId: merchantId,
    storeId: storeId,
    name: name,
    taxRate: taxRate,
    basePrice: basePrice,
    sellingPrice: sellingPrice,
    isActive: isActive,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    sku: sku,
    barcode: barcode,
    description: description,
    imageUrl: imageUrl,
    categoryId: categoryId,
    counterId: counterId,
  );
}

/// Test factory for [StockRow].
StockRow createStockRow({
  String id = 'stock-1',
  String productId = 'p-1',
  String storeId = 'store-1',
  int quantity = 100,
  int lowStockThreshold = 10,
  bool stockMonitor = false,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return constructStockRow(
    id: id,
    productId: productId,
    storeId: storeId,
    quantity: quantity,
    lowStockThreshold: lowStockThreshold,
    stockMonitor: stockMonitor,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

/// Test factory for [StockTransactionRow].
StockTransactionRow createStockTransactionRow({
  String id = 'stock-tx-1',
  String productId = 'p-1',
  String storeId = 'store-1',
  String adjustmentType = 'add',
  int quantity = 50,
  String reason = 'restock',
  String? customReason,
  DateTime? createdAt,
}) {
  return constructStockTransactionRow(
    id: id,
    productId: productId,
    storeId: storeId,
    adjustmentType: adjustmentType,
    quantity: quantity,
    reason: reason,
    createdAt: createdAt ?? DateTime.now(),
    customReason: customReason,
  );
}
