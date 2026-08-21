import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_actions.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';

/// Helper to execute stock level updates, adjustments, and threshold changes.
class UpdateStockHandler {
  const UpdateStockHandler._();

  /// Validates inputs and triggers stock adjustment action.
  static void submitStockUpdate({
    required Product product,
    required StockTransactionType transactionType,
    required String amountStr,
    required String lowStockThresholdStr,
    required bool stockMonitor,
    required StockTransactionReason reason,
    required String customReason,
  }) {
    final amountTrimmed = amountStr.trim();
    final lowStockThreshold = int.tryParse(lowStockThresholdStr.trim());
    final currentQty = product.stock?.quantity ?? 0;
    final stockId = product.stock?.id;

    if (stockId == null) {
      showToast('Stock record not found for this product.');
      return;
    }

    if (stockMonitor && lowStockThreshold == null) {
      showToast('Low Stock Threshold is required when Stock Monitor is enabled.');
      return;
    }

    final int? inputAmount = amountTrimmed.isEmpty ? null : int.tryParse(amountTrimmed);
    if (amountTrimmed.isNotEmpty && (inputAmount == null || inputAmount < 0)) {
      showToast('Please enter a valid non-negative quantity.');
      return;
    }

    final isAdjustment = inputAmount != null;
    if (isAdjustment && transactionType == StockTransactionType.reduce) {
      if (currentQty <= 0) {
        showToast('Cannot reduce stock because current inventory is 0 units.');
        return;
      }
      if (inputAmount > currentQty) {
        showToast('Cannot reduce $inputAmount units. Maximum available is $currentQty units.');
        return;
      }
    }

    final computedFinalQuantity = isAdjustment ? switch (transactionType) {
      .add => currentQty + inputAmount,
      .reduce => (currentQty - inputAmount).clamp(0, 999999),
      .set => inputAmount,
    } : null;

    final isReduction = isAdjustment && (transactionType == StockTransactionType.reduce || (transactionType == StockTransactionType.set && (computedFinalQuantity ?? currentQty) < currentQty));
    final effectiveReason = isReduction ? reason : StockTransactionReason.restock;

    ProductsActions.updateStock(
      stockId: stockId,
      productId: product.id,
      quantity: computedFinalQuantity,
      lowStockThreshold: stockMonitor ? lowStockThreshold : null,
      stockMonitor: stockMonitor,
      transactionType: isAdjustment ? transactionType : null,
      amount: inputAmount,
      reason: isAdjustment ? effectiveReason : null,
      customReason: isReduction && customReason.trim().isNotEmpty ? customReason.trim() : null,
    );

    activeModalSignal.value = ActiveModal.none;
    showToast(isAdjustment ? 'Stock updated successfully.' : 'Stock settings updated successfully.', type: ToastType.success);
  }
}
