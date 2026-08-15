import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
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
    final inputAmount = int.tryParse(amountStr.trim());
    final lowStockThreshold = int.tryParse(lowStockThresholdStr.trim());
    final currentQty = product.stock?.quantity ?? 0;

    if (inputAmount == null || inputAmount < 0) {
      showToast('Please enter a valid non-negative quantity.');
      return;
    }

    if (stockMonitor && lowStockThreshold == null) {
      showToast(
        'Low Stock Threshold is required when Stock Monitor is enabled.',
      );
      return;
    }

    final computedFinalQuantity = switch (transactionType) {
      .add => currentQty + inputAmount,
      .reduce => (currentQty - inputAmount).clamp(0, 999999),
      .set => inputAmount,
    };

    final showReasonSection =
        transactionType == StockTransactionType.reduce ||
        transactionType == StockTransactionType.set;

    final stockId = product.stock?.id;
    if (stockId != null) {
      ProductsActions.updateStock(
        stockId: stockId,
        productId: product.id,
        quantity: computedFinalQuantity,
        lowStockThreshold: stockMonitor ? lowStockThreshold : null,
        stockMonitor: stockMonitor,
        transactionType: transactionType,
        amount: inputAmount,
        reason: showReasonSection ? reason : null,
        customReason: showReasonSection && customReason.trim().isNotEmpty
            ? customReason.trim()
            : null,
      );
      activeModalSignal.value = ActiveModal.none;
    } else {
      showToast('Stock record not found for this product.');
    }
  }
}
