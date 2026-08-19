import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/add_edit_product_form.dart';
import 'package:terminal/components/inventory/modals/product_dialog_actions.dart';
import 'package:terminal/components/inventory/modals/product_form_submit_handler.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';

/// Modal dialog for adding a new product or editing an existing product.
class AddEditProductDialog extends StatefulWidget {
  final Product? product;

  const AddEditProductDialog({super.key, this.product});

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  late String _name, _categoryId, _counterId, _basePrice, _sellingPrice, _taxRate, _sku, _barcode, _imageUrl;
  late bool _isActive;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = p?.name ?? '';
    _categoryId = p?.category?.id ?? '';
    _counterId = p?.counter?.id ?? '';
    _basePrice = p != null ? '${p.basePrice}' : '';
    _sellingPrice = p != null ? '${p.sellingPrice}' : '';
    _taxRate = p != null ? '${p.taxRate}' : '0';
    _sku = p?.sku ?? '';
    _barcode = p?.barcode ?? '';
    _imageUrl = p?.imageUrl ?? '';
    _isActive = p?.isActive ?? true;

    if (categoriesSignal.value.value == null) refreshCategoriesSignal();
    if (countersSignal.value.value == null) refreshCountersSignal();
  }

  Future<void> _handleSubmit() async {
    if (_name.trim().isEmpty || _categoryId.trim().isEmpty) {
      showFToast(context: context, alignment: .topCenter, title: const Text('Validation Error'), description: Text(_name.trim().isEmpty ? 'Product name is required.' : 'Category is required.'));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await ProductFormSubmitHandler.submit(
        product: widget.product,
        name: _name,
        categoryId: _categoryId,
        counterId: _counterId,
        basePriceStr: _basePrice,
        sellingPriceStr: _sellingPrice,
        taxRateStr: _taxRate,
        sku: _sku,
        barcode: _barcode,
        imageUrl: _imageUrl,
        isActive: _isActive,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      showFToast(context: context, alignment: .topCenter, title: const Text('Success'), description: Text(widget.product != null ? 'Product updated.' : 'Product created.'));
    } catch (e) {
      if (!mounted) return;
      showFToast(context: context, alignment: .topCenter, title: const Text('Error'), description: Text(e.toString()));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFFFFFFF),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: SignalBuilder(
            builder: (context) {
              final categories = categoriesSignal.value.value ?? [];
              final counters = countersSignal.value.value ?? [];

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isEditing ? 'Edit Product' : 'Add New Product', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                      GestureDetector(onTap: () => Navigator.of(context).pop(), child: const MouseRegion(cursor: SystemMouseCursors.click, child: Icon(FLucideIcons.x, size: 18, color: Color(0xFF94A3B8)))),
                    ],
                  ),
                  const Gap(16),
                  Flexible(
                    child: AddEditProductForm(
                      name: _name,
                      categoryId: _categoryId,
                      counterId: _counterId,
                      sku: _sku,
                      barcode: _barcode,
                      imageUrl: _imageUrl,
                      isActive: _isActive,
                      isEditing: isEditing,
                      basePrice: _basePrice,
                      sellingPrice: _sellingPrice,
                      taxRate: _taxRate,
                      categories: categories,
                      counters: counters,
                      onNameChanged: (v) => _name = v,
                      onCategoryChanged: (v) => setState(() => _categoryId = v),
                      onCounterChanged: (v) => setState(() => _counterId = v),
                      onSkuChanged: (v) => _sku = v,
                      onBarcodeChanged: (v) => _barcode = v,
                      onImageUrlChanged: (v) => _imageUrl = v,
                      onActiveChanged: (v) => setState(() => _isActive = v),
                      onBasePriceChanged: (v) => _basePrice = v,
                      onSellingPriceChanged: (v) => _sellingPrice = v,
                      onTaxRateChanged: (v) => _taxRate = v,
                    ),
                  ),
                  const Gap(18),
                  ProductDialogActions(
                    isSubmitting: _isSubmitting,
                    isEditing: isEditing,
                    onSubmit: _handleSubmit,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
