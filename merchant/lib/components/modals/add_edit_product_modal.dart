import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/category_selector_field.dart';
import 'package:merchant/components/fields/counter_selector_field.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/fields/product_pricing_fields.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/components/modals/product_metadata_section.dart';
import 'package:merchant/components/modals/product_modal_submit_handler.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
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

  @override
  void initState() {
    super.initState();
    final p = component.product;
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
    refreshCategoriesSignal(customSize: 1000, ignoreSearch: true);
    refreshCountersSignal(customSize: 1000, ignoreSearch: true);
  }

  void _onSubmit(web.Event e) {
    e.preventDefault();
    (web.document.activeElement as web.HTMLElement?)?.blur();
    if (_categoryId.isEmpty) {
      showToast('Category is required.');
      return;
    }
    activeModalSignal.value = ActiveModal.none;
    ProductModalSubmitHandler.submit(
      product: component.product,
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
  }

  @override
  Component buildSignal(BuildContext context) {
    final categories = categoriesSignal.value.value ?? [];
    final counters = countersSignal.value.value ?? [];

    return Modal(
      title: component.product != null ? 'Edit Product' : 'Add Product',
      child: form(
        classes: 'w-full flex flex-col',
        events: {'submit': _onSubmit},
        [
          div(
            classes: 'flex flex-col gap-4',
            [
              FormField(
                id: 'productName',
                labelText: 'Product Name',
                type: InputType.text,
                attributes: {'placeholder': 'Amul Butter 500g', 'required': '', 'value': _name},
                hintText: 'Product name is required.',
                onChange: (val) => _name = val as String,
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
              classes: 'btn btn-primary px-6 h-10 rounded-xl font-bold text-sm shadow-xs transition-all cursor-pointer',
              [.text('Save')],
            ),
          ]),
        ],
      ),
    );
  }
}
