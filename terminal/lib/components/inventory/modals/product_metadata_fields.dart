import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';

/// Form fields for product name, category, counter, identifiers, and active status.
class ProductMetadataFields extends StatelessWidget {
  final String name;
  final String categoryId;
  final String counterId;
  final String sku;
  final String barcode;
  final String imageUrl;
  final bool isActive;
  final bool isEditing;
  final List<Category> categories;
  final List<Counter> counters;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onCounterChanged;
  final ValueChanged<String> onSkuChanged;
  final ValueChanged<String> onBarcodeChanged;
  final ValueChanged<String> onImageUrlChanged;
  final ValueChanged<bool> onActiveChanged;

  const ProductMetadataFields({
    super.key,
    required this.name,
    required this.categoryId,
    required this.counterId,
    required this.sku,
    required this.barcode,
    required this.imageUrl,
    required this.isActive,
    required this.isEditing,
    required this.categories,
    required this.counters,
    required this.onNameChanged,
    required this.onCategoryChanged,
    required this.onCounterChanged,
    required this.onSkuChanged,
    required this.onBarcodeChanged,
    required this.onImageUrlChanged,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: TextEditingController(text: name)..selection = TextSelection.collapsed(offset: name.length),
          onChanged: onNameChanged,
          decoration: InputDecoration(labelText: 'Product Name*', hintText: 'Enter name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: categoryId.isEmpty ? null : categoryId,
                isExpanded: true,
                decoration: InputDecoration(labelText: 'Category*', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (val) => onCategoryChanged(val ?? ''),
              ),
            ),
            const Gap(10),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: counterId.isEmpty ? null : counterId,
                isExpanded: true,
                decoration: InputDecoration(labelText: 'Counter (Optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                items: [
                  const DropdownMenuItem(value: '', child: Text('No Counter')),
                  ...counters.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis))),
                ],
                onChanged: (val) => onCounterChanged(val ?? ''),
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: sku)..selection = TextSelection.collapsed(offset: sku.length),
                onChanged: onSkuChanged,
                decoration: InputDecoration(labelText: 'SKU (Optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const Gap(10),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: barcode)..selection = TextSelection.collapsed(offset: barcode.length),
                onChanged: onBarcodeChanged,
                decoration: InputDecoration(labelText: 'Barcode (Optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ],
        ),
        const Gap(12),
        TextField(
          controller: TextEditingController(text: imageUrl)..selection = TextSelection.collapsed(offset: imageUrl.length),
          onChanged: onImageUrlChanged,
          decoration: InputDecoration(labelText: 'Image URL (Optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
        if (isEditing) ...[
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Status', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
              Switch.adaptive(value: isActive, activeThumbColor: const Color(0xFF000000), onChanged: onActiveChanged),
            ],
          ),
        ],
      ],
    );
  }
}
