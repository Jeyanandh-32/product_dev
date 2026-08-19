import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/products_signal.dart';

/// Product actions executor handling create, update, and stock modification in Terminal.
abstract final class InventoryStockActions {
  static Future<Product> createProduct({
    required String name,
    required String categoryId,
    String? counterId,
    required double basePrice,
    required double sellingPrice,
    double? taxRate,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
  }) async {
    final terminal = authSignal.value.value;
    if (terminal == null) throw const ApiException('Terminal not logged in.');

    final product = await ProductRepository.create(
      storeId: terminal.storeId,
      name: name,
      categoryId: categoryId,
      counterId: counterId,
      basePrice: basePrice,
      sellingPrice: sellingPrice,
      taxRate: taxRate,
      sku: sku,
      barcode: barcode,
      description: description,
      imageUrl: imageUrl,
    );

    final current = productsSignal.value.value ?? [];
    productsSignal.value = AsyncData([...current, product]);
    return product;
  }

  static Future<Product> updateProduct({
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
    final updated = await ProductRepository.update(
      id: id,
      name: name,
      categoryId: categoryId,
      counterId: counterId,
      isActive: isActive,
      basePrice: basePrice,
      sellingPrice: sellingPrice,
      taxRate: taxRate,
      sku: sku,
      barcode: barcode,
      description: description,
      imageUrl: imageUrl,
    );

    final current = productsSignal.value.value ?? [];
    productsSignal.value = AsyncData(current.map((p) => p.id == id ? updated : p).toList());
    return updated;
  }

  static Future<Stock> updateStock({
    required String stockId,
    required String productId,
    required int quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
    StockTransactionType? transactionType,
    int? amount,
    StockTransactionReason? reason,
    String? customReason,
  }) async {
    final stock = await StockRepository.update(
      id: stockId,
      quantity: quantity,
      lowStockThreshold: lowStockThreshold,
      stockMonitor: stockMonitor,
      transactionType: transactionType,
      amount: amount,
      reason: reason,
      customReason: customReason,
    );

    final current = productsSignal.value.value ?? [];
    productsSignal.value = AsyncData(
      current.map((p) => p.id == productId ? p.copyWith(stock: stock) : p).toList(),
    );
    return stock;
  }
}
