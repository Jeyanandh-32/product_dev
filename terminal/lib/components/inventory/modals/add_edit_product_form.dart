import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/product_metadata_fields.dart';
import 'package:terminal/components/inventory/modals/product_pricing_fields.dart';

/// Form body combining metadata and pricing sections for product modal.
class AddEditProductForm extends StatelessWidget {
  final String name;
  final String categoryId;
  final String counterId;
  final String sku;
  final String barcode;
  final String imageUrl;
  final bool isActive;
  final bool isEditing;
  final String basePrice;
  final String sellingPrice;
  final String taxRate;
  final List<Category> categories;
  final List<Counter> counters;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onCounterChanged;
  final ValueChanged<String> onSkuChanged;
  final ValueChanged<String> onBarcodeChanged;
  final ValueChanged<String> onImageUrlChanged;
  final ValueChanged<bool> onActiveChanged;
  final ValueChanged<String> onBasePriceChanged;
  final ValueChanged<String> onSellingPriceChanged;
  final ValueChanged<String> onTaxRateChanged;

  const AddEditProductForm({
    super.key,
    required this.name,
    required this.categoryId,
    required this.counterId,
    required this.sku,
    required this.barcode,
    required this.imageUrl,
    required this.isActive,
    required this.isEditing,
    required this.basePrice,
    required this.sellingPrice,
    required this.taxRate,
    required this.categories,
    required this.counters,
    required this.onNameChanged,
    required this.onCategoryChanged,
    required this.onCounterChanged,
    required this.onSkuChanged,
    required this.onBarcodeChanged,
    required this.onImageUrlChanged,
    required this.onActiveChanged,
    required this.onBasePriceChanged,
    required this.onSellingPriceChanged,
    required this.onTaxRateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProductMetadataFields(
            name: name,
            categoryId: categoryId,
            counterId: counterId,
            sku: sku,
            barcode: barcode,
            imageUrl: imageUrl,
            isActive: isActive,
            isEditing: isEditing,
            categories: categories,
            counters: counters,
            onNameChanged: onNameChanged,
            onCategoryChanged: onCategoryChanged,
            onCounterChanged: onCounterChanged,
            onSkuChanged: onSkuChanged,
            onBarcodeChanged: onBarcodeChanged,
            onImageUrlChanged: onImageUrlChanged,
            onActiveChanged: onActiveChanged,
          ),
          const Gap(12),
          ProductPricingFields(
            basePrice: basePrice,
            sellingPrice: sellingPrice,
            taxRate: taxRate,
            onBasePriceChanged: onBasePriceChanged,
            onSellingPriceChanged: onSellingPriceChanged,
            onTaxRateChanged: onTaxRateChanged,
          ),
        ],
      ),
    );
  }
}
