import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/add_edit_product_form.dart';
import 'package:terminal/components/inventory/modals/product_dialog_actions.dart';
import 'package:terminal/components/inventory/modals/product_form_submit_handler.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/counters_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Modal dialog for adding a new product or editing an existing product matching Merchant design.
class AddEditProductDialog extends StatefulWidget {
  final Product? product;
  const AddEditProductDialog({super.key, this.product});

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  String _name = '';
  String _categoryId = '';
  String _counterId = '';
  String _basePrice = '';
  String _sellingPrice = '';
  String _taxRate = '0';
  String _sku = '';
  String _barcode = '';
  String _imageUrl = '';
  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _name = p.name;
      _categoryId = p.category?.id ?? '';
      _counterId = p.counter?.id ?? '';
      _basePrice = '${p.basePrice}';
      _sellingPrice = '${p.sellingPrice}';
      _taxRate = '${p.taxRate}';
      _sku = p.sku ?? '';
      _barcode = p.barcode ?? '';
      _imageUrl = p.imageUrl ?? '';
      _isActive = p.isActive;
    }
    if (categoriesSignal.value.value == null) refreshCategoriesSignal();
    if (countersSignal.value.value == null) refreshCountersSignal();
  }

  Future<void> _handleSubmit() async {
    if (_name.trim().isEmpty || _categoryId.trim().isEmpty) {
      TerminalToast.showError(
        context: context,
        title: 'Validation Error',
        description: _name.trim().isEmpty ? 'Product name is required.' : 'Category is required.',
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await ProductFormSubmitHandler.submit(
        product: widget.product, name: _name, categoryId: _categoryId, counterId: _counterId,
        basePriceStr: _basePrice, sellingPriceStr: _sellingPrice, taxRateStr: _taxRate,
        sku: _sku, barcode: _barcode, imageUrl: _imageUrl, isActive: _isActive,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      TerminalToast.showSuccess(
        context: context,
        title: widget.product != null ? 'Product Updated' : 'Product Created',
        description: '${_name.trim()} saved successfully.',
      );
    } catch (e) {
      if (!mounted) return;
      TerminalToast.showError(context: context, title: 'Error', description: e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE2E8F0))),
      backgroundColor: const Color(0xFFFFFFFF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 540, maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SignalBuilder(builder: (context) {
            final categories = categoriesSignal.value.value ?? [];
            final counters = countersSignal.value.value ?? [];

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isEditing ? 'Edit Product' : 'Add New Product', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: PressableBox(
                        onPress: () => Navigator.of(context).pop(),
                        style: BoxStyler().width(32).height(32).borderRadiusAll(const Radius.circular(999)).borderAll(color: const Color(0xFFE2E8F0)).color(const Color(0xFFFFFFFF)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFF8FAFC))),
                        child: const Icon(FLucideIcons.x, size: 16, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Flexible(
                  child: SingleChildScrollView(
                    child: AddEditProductForm(
                      name: _name, categoryId: _categoryId, counterId: _counterId, sku: _sku, barcode: _barcode,
                      imageUrl: _imageUrl, isActive: _isActive, isEditing: isEditing, basePrice: _basePrice,
                      sellingPrice: _sellingPrice, taxRate: _taxRate, categories: categories, counters: counters,
                      onNameChanged: (v) => _name = v, onCategoryChanged: (v) => setState(() => _categoryId = v),
                      onCounterChanged: (v) => setState(() => _counterId = v), onSkuChanged: (v) => _sku = v,
                      onBarcodeChanged: (v) => _barcode = v, onImageUrlChanged: (v) => _imageUrl = v,
                      onActiveChanged: (v) => setState(() => _isActive = v), onBasePriceChanged: (v) => _basePrice = v,
                      onSellingPriceChanged: (v) => _sellingPrice = v, onTaxRateChanged: (v) => _taxRate = v,
                    ),
                  ),
                ),
                const Gap(18),
                ProductDialogActions(isSubmitting: _isSubmitting, isEditing: isEditing, onSubmit: _handleSubmit),
              ],
            );
          }),
        ),
      ),
    );
  }
}
