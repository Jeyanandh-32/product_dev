class StockValidator {
  const StockValidator._();

  static String? create({
    required String? productId,
    required String? storeId,
    int? quantity,
    int? lowStockThreshold,
  }) {
    if (productId == null || productId.trim().isEmpty) {
      return 'Product ID is required.';
    }
    if (storeId == null || storeId.trim().isEmpty) {
      return 'Store ID is required.';
    }
    if (quantity != null && quantity < 0) {
      return 'Quantity cannot be negative.';
    }
    if (lowStockThreshold != null && lowStockThreshold < 0) {
      return 'Low stock threshold cannot be negative.';
    }
    return null;
  }

  static String? update({
    int? quantity,
    int? lowStockThreshold,
    bool quantityPresent = false,
    bool lowStockThresholdPresent = false,
  }) {
    if (quantityPresent && quantity != null && quantity < 0) {
      return 'Quantity cannot be negative.';
    }
    if (lowStockThresholdPresent && lowStockThreshold != null && lowStockThreshold < 0) {
      return 'Low stock threshold cannot be negative.';
    }
    if (!quantityPresent && !lowStockThresholdPresent) {
      return 'At least one field is required to update.';
    }
    return null;
  }
}
