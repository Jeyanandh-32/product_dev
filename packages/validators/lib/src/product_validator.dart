class ProductValidator {
  const ProductValidator._();

  static String? create({
    required String? name,
    required String? categoryId,
    required String? counterId,
    required int? basePrice,
    required int? sellingPrice,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    double? taxRate,
  }) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required.';
    }
    if (name.length > 255) {
      return 'Name must be 255 characters or fewer.';
    }
    if (categoryId == null || categoryId.trim().isEmpty) {
      return 'Category ID is required.';
    }
    if (counterId == null || counterId.trim().isEmpty) {
      return 'Counter ID is required.';
    }
    if (basePrice == null) {
      return 'Base price is required.';
    }
    if (basePrice < 0) {
      return 'Base price cannot be negative.';
    }
    if (sellingPrice == null) {
      return 'Selling price is required.';
    }
    if (sellingPrice < 0) {
      return 'Selling price cannot be negative.';
    }
    if (sku != null && sku.length > 100) {
      return 'SKU must be 100 characters or fewer.';
    }
    if (barcode != null && barcode.length > 100) {
      return 'Barcode must be 100 characters or fewer.';
    }
    if (description != null && description.length > 255) {
      return 'Description must be 255 characters or fewer.';
    }
    if (imageUrl != null && imageUrl.length > 255) {
      return 'Image URL must be 255 characters or fewer.';
    }
    if (taxRate != null && taxRate < 0) {
      return 'Tax rate cannot be negative.';
    }
    return null;
  }

  static String? update({
    String? name,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    double? taxRate,
    int? basePrice,
    int? sellingPrice,
    bool? isActive,
    String? categoryId,
    String? counterId,
    bool namePresent = false,
    bool skuPresent = false,
    bool barcodePresent = false,
    bool descriptionPresent = false,
    bool imageUrlPresent = false,
    bool taxRatePresent = false,
    bool basePricePresent = false,
    bool sellingPricePresent = false,
    bool isActivePresent = false,
    bool categoryIdPresent = false,
    bool counterIdPresent = false,
  }) {
    if (namePresent) {
      if (name == null || name.trim().isEmpty) {
        return 'Name cannot be empty.';
      }
      if (name.length > 255) {
        return 'Name must be 255 characters or fewer.';
      }
    }
    if (skuPresent && sku != null && sku.length > 100) {
      return 'SKU must be 100 characters or fewer.';
    }
    if (barcodePresent && barcode != null && barcode.length > 100) {
      return 'Barcode must be 100 characters or fewer.';
    }
    if (descriptionPresent && description != null && description.length > 255) {
      return 'Description must be 255 characters or fewer.';
    }
    if (imageUrlPresent && imageUrl != null && imageUrl.length > 255) {
      return 'Image URL must be 255 characters or fewer.';
    }
    if (taxRatePresent && taxRate != null && taxRate < 0) {
      return 'Tax rate cannot be negative.';
    }
    if (basePricePresent && basePrice != null && basePrice < 0) {
      return 'Base price cannot be negative.';
    }
    if (sellingPricePresent && sellingPrice != null && sellingPrice < 0) {
      return 'Selling price cannot be negative.';
    }

    if (!namePresent &&
        !skuPresent &&
        !barcodePresent &&
        !descriptionPresent &&
        !imageUrlPresent &&
        !taxRatePresent &&
        !basePricePresent &&
        !sellingPricePresent &&
        !isActivePresent &&
        !categoryIdPresent &&
        !counterIdPresent) {
      return 'At least one field is required to update.';
    }

    return null;
  }
}
