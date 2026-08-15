import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/category_selector_field.dart';
import 'package:merchant/components/fields/counter_selector_field.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/fields/product_pricing_fields.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/components/modals/product_metadata_section.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Modal dialog for adding new products and editing existing product specifications.
class AddEditProductModal extends SignalComponent {
  const AddEditProductModal({super.key, this.product});

  final Product? product;

  @override
  SignalState<AddEditProductModal> createState() => _AddEditProductModalState();
}

class _AddEditProductModalState extends SignalState<AddEditProductModal> {
  late String _name;
  late String _categoryId;
  late String _counterId;
  late String _basePrice;
  late String _sellingPrice;
  late String _taxRate;
  late String _sku;
  late String _barcode;
  late String _imageUrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final p = component.product;
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

    refreshCategoriesSignal(customSize: 1000);
    refreshCountersSignal(customSize: 1000);
  }

  void _onSubmit(web.Event e) {
    e.preventDefault();

    if (_categoryId.isEmpty) {
      showToast('Category is required.');
      return;
    }

    activeModalSignal.value = ActiveModal.none;

    final basePrice = double.tryParse(_basePrice.trim()) ?? 0.0;
    final sellingPrice = double.tryParse(_sellingPrice.trim()) ?? 0.0;
    final taxRate = double.tryParse(_taxRate.trim()) ?? 0.0;
    final counterIdParam = _counterId.trim().isEmpty ? null : _counterId;

    if (component.product != null) {
      ProductsActions.updateProduct(
        id: component.product!.id,
        name: _name.trim().isNotEmpty ? _name : null,
        categoryId: _categoryId.trim().isNotEmpty ? _categoryId : null,
        counterId: counterIdParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: _sku.trim().isNotEmpty ? _sku : null,
        barcode: _barcode.trim().isNotEmpty ? _barcode : null,
        imageUrl: _imageUrl.trim().isNotEmpty ? _imageUrl : null,
        isActive: _isActive,
      );
    } else {
      ProductsActions.create(
        name: _name,
        categoryId: _categoryId,
        counterId: counterIdParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: _sku.trim().isNotEmpty ? _sku : null,
        barcode: _barcode.trim().isNotEmpty ? _barcode : null,
        imageUrl: _imageUrl.trim().isNotEmpty ? _imageUrl : null,
      );
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final categories = categoriesSignal.value.value ?? [];
    final counters = countersSignal.value.value ?? [];

    return Modal(
      title: component.product != null ? 'Edit Product' : 'Add Product',
      child: form(
        events: {'submit': _onSubmit},
        classes: 'flex flex-col gap-4',
        [
          div(
            classes: 'flex flex-col gap-4 max-h-[60vh] overflow-y-auto px-1',
            [
              FormField(
                id: 'name',
                labelText: 'Name',
                type: InputType.text,
                attributes: {
                  'placeholder': 'Product name',
                  'required': 'true',
                  'value': _name,
                },
                onChange: (value) => _name = value as String,
              ),

              CategorySelectorField(
                categories: categories,
                categoryId: _categoryId,
                onSelect: (val) => setState(() => _categoryId = val),
              ),

              CounterSelectorField(
                counters: counters,
                counterId: _counterId,
                onSelect: (val) => setState(() => _counterId = val),
              ),

              ProductPricingFields(
                basePrice: _basePrice,
                sellingPrice: _sellingPrice,
                taxRate: _taxRate,
                onBasePriceChanged: (val) => _basePrice = val,
                onSellingPriceChanged: (val) => _sellingPrice = val,
                onTaxRateChanged: (val) => _taxRate = val,
              ),

              ProductMetadataSection(
                sku: _sku,
                barcode: _barcode,
                imageUrl: _imageUrl,
                isActive: _isActive,
                isEditing: component.product != null,
                onSkuChanged: (val) => _sku = val,
                onBarcodeChanged: (val) => _barcode = val,
                onImageUrlChanged: (val) => _imageUrl = val,
                onActiveChanged: (val) => setState(() => _isActive = val),
              ),
            ],
          ),

          div(classes: 'flex justify-end items-center pt-2', [
            button(
              type: ButtonType.submit,
              classes:
                  'bg-primary text-primary-content px-6 h-10 rounded-lg hover:cursor-pointer hover:bg-opacity-80 transition-all duration-300',
              [
                .text('Save'),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
