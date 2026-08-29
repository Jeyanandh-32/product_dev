import 'package:flutter/widgets.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/inventory_stock_actions.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Helper handler encapsulating validation and dispatch logic for stock updates.
abstract final class UpdateStockHandler {
  static Future<bool> submit({
    required BuildContext context,
    required Product product,
    required StockTransactionType type,
    required String amount,
    required StockTransactionReason reason,
    required String customReason,
    required bool monitor,
    required String lowThreshold,
  }) async {
    final amountTrimmed = amount.trim();
    final lowStockThreshold = int.tryParse(lowThreshold.trim());
    final currentQty = product.stock?.quantity ?? 0;
    final stockId = product.stock?.id;
    if (stockId == null) return false;

    if (monitor && lowStockThreshold == null) {
      TerminalToast.showError(
        context: context,
        title: 'Validation Error',
        description: 'Low stock limit is required when monitoring is enabled.',
      );
      return false;
    }
    final int? inputAmount = amountTrimmed.isEmpty ? null : int.tryParse(amountTrimmed);
    if (amountTrimmed.isNotEmpty && (inputAmount == null || inputAmount < 0)) {
      TerminalToast.showError(
        context: context,
        title: 'Invalid Quantity',
        description: 'Please enter a valid non-negative quantity.',
      );
      return false;
    }
    final isAdjustment = inputAmount != null;
    if (isAdjustment && type == StockTransactionType.reduce) {
      if (currentQty <= 0) {
        TerminalToast.showError(
          context: context,
          title: 'Invalid Action',
          description: 'Cannot reduce stock because current inventory is 0 units.',
        );
        return false;
      }
      if (inputAmount > currentQty) {
        TerminalToast.showError(
          context: context,
          title: 'Invalid Quantity',
          description: 'Cannot reduce $inputAmount units. Maximum available is $currentQty units.',
        );
        return false;
      }
    }
    final finalQty = isAdjustment
        ? switch (type) {
            StockTransactionType.add => currentQty + inputAmount,
            StockTransactionType.reduce => (currentQty - inputAmount).clamp(0, 999999),
            StockTransactionType.set => inputAmount,
          }
        : null;

    final isReduction = isAdjustment &&
        (type == StockTransactionType.reduce ||
            (type == StockTransactionType.set && (finalQty ?? currentQty) < currentQty));
    final effectiveReason = isReduction ? reason : StockTransactionReason.restock;

    try {
      await InventoryStockActions.updateStock(
        stockId: stockId,
        productId: product.id,
        quantity: finalQty,
        lowStockThreshold: monitor ? lowStockThreshold : null,
        stockMonitor: monitor,
        transactionType: isAdjustment ? type : null,
        amount: inputAmount,
        reason: isAdjustment ? effectiveReason : null,
        customReason: isReduction && customReason.trim().isNotEmpty ? customReason.trim() : null,
      );
      if (context.mounted) {
        TerminalToast.showSuccess(
          context: context,
          title: isAdjustment ? 'Stock Updated' : 'Settings Saved',
          description: isAdjustment
              ? '${product.name} stock is now $finalQty units.'
              : 'Monitoring settings updated for ${product.name}.',
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        TerminalToast.showError(context: context, title: 'Update Failed', description: e.toString());
      }
      return false;
    }
  }
}
