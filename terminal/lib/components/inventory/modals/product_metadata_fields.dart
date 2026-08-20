import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/modal_select_field.dart';

/// Form fields for product name, category, counter, and identifiers.
class ProductMetadataFields extends StatelessWidget {
  final String name;
  final String categoryId;
  final String counterId;
  final String sku;
  final String barcode;
  final String imageUrl;
  final List<Category> categories;
  final List<Counter> counters;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onCounterChanged;
  final ValueChanged<String> onSkuChanged;
  final ValueChanged<String> onBarcodeChanged;
  final ValueChanged<String> onImageUrlChanged;

  const ProductMetadataFields({
    super.key,
    required this.name,
    required this.categoryId,
    required this.counterId,
    required this.sku,
    required this.barcode,
    required this.imageUrl,
    required this.categories,
    required this.counters,
    required this.onNameChanged,
    required this.onCategoryChanged,
    required this.onCounterChanged,
    required this.onSkuChanged,
    required this.onBarcodeChanged,
    required this.onImageUrlChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModalInputField(
          label: 'Product Name',
          hint: 'e.g. Masala Chai 250ml',
          value: name,
          isRequired: true,
          onChanged: onNameChanged,
        ),
        const Gap(14),
        Row(
          children: [
            Expanded(
              child: ModalSelectField<String>(
                label: 'Category',
                value: categoryId.isEmpty ? null : categoryId,
                isRequired: true,
                hint: 'Select category',
                items: categories.map((c) => (label: c.name, value: c.id)).toList(),
                onChanged: (val) => onCategoryChanged(val ?? ''),
              ),
            ),
            const Gap(12),
            Expanded(
              child: ModalSelectField<String>(
                label: 'Counter',
                value: counterId.isEmpty ? null : counterId,
                hint: 'No counter',
                items: [
                  (label: 'No Counter', value: ''),
                  ...counters.map((c) => (label: c.name, value: c.id)),
                ],
                onChanged: (val) => onCounterChanged(val ?? ''),
              ),
            ),
          ],
        ),
        const Gap(14),
        Row(
          children: [
            Expanded(
              child: ModalInputField(
                label: 'SKU',
                hint: 'e.g. CHAI-001',
                value: sku,
                onChanged: onSkuChanged,
              ),
            ),
            const Gap(12),
            Expanded(
              child: ModalInputField(
                label: 'Barcode',
                hint: 'e.g. 8901234567890',
                value: barcode,
                onChanged: onBarcodeChanged,
              ),
            ),
          ],
        ),
        const Gap(14),
        ModalInputField(
          label: 'Image URL',
          hint: 'https://images.unsplash.com/...',
          value: imageUrl,
          onChanged: onImageUrlChanged,
        ),
      ],
    );
  }
}
