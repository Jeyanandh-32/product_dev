import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/category_selector_field.dart';
import 'package:merchant/components/fields/counter_selector_field.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/fields/product_pricing_fields.dart';
import 'package:merchant/components/modals/modal.dart';
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
        name: _name.trim(),
        categoryId: _categoryId,
        counterId: counterIdParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        isActive: _isActive,
        sku: _sku.trim().isEmpty ? null : _sku.trim(),
        barcode: _barcode.trim().isEmpty ? null : _barcode.trim(),
        imageUrl: _imageUrl.trim().isEmpty ? null : _imageUrl.trim(),
      );
    } else {
      ProductsActions.create(
        name: _name.trim(),
        categoryId: _categoryId,
        counterId: counterIdParam,
        basePrice: basePrice,
        sellingPrice: sellingPrice,
        taxRate: taxRate,
        sku: _sku.trim().isEmpty ? null : _sku.trim(),
        barcode: _barcode.trim().isEmpty ? null : _barcode.trim(),
        imageUrl: _imageUrl.trim().isEmpty ? null : _imageUrl.trim(),
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
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(e)},
        [
          div(
            classes:
                'max-h-[60vh] overflow-y-auto overflow-x-hidden flex flex-col gap-0 px-3',
            [
              FormField(
                id: 'productName',
                labelText: 'Product Name',
                type: InputType.text,
                attributes: {
                  'placeholder': 'Oreo Biscuits',
                  'required': '',
                  'value': _name,
                },
                hintText: 'Product name is required.',
                onChange: (value) => _name = value as String,
              ),

              CategorySelectorField(
                categoryId: _categoryId,
                categories: categories,
                onSelect: (id) => setState(() => _categoryId = id),
              ),

              CounterSelectorField(
                counterId: _counterId,
                counters: counters,
                onSelect: (id) => setState(() => _counterId = id),
              ),

              ProductPricingFields(
                basePrice: _basePrice,
                sellingPrice: _sellingPrice,
                taxRate: _taxRate,
                onBasePriceChanged: (val) => _basePrice = val,
                onSellingPriceChanged: (val) => _sellingPrice = val,
                onTaxRateChanged: (val) => _taxRate = val,
              ),

              FormField(
                id: 'sku',
                labelText: 'SKU (optional)',
                type: InputType.text,
                attributes: {
                  'placeholder': 'DF-BISCUIT-01',
                  'value': _sku,
                },
                onChange: (value) => _sku = value as String,
              ),
              FormField(
                id: 'barcode',
                labelText: 'Barcode (optional)',
                type: InputType.text,
                attributes: {
                  'placeholder': '8901728281223',
                  'value': _barcode,
                },
                onChange: (value) => _barcode = value as String,
              ),

              FormField(
                id: 'imageUrl',
                labelText: 'Image URL (optional)',
                type: InputType.url,
                attributes: {
                  'placeholder': 'https://example.com/image.png',
                  'value': _imageUrl,
                },
                onChange: (value) => _imageUrl = value as String,
              ),

              if (component.product != null)
                div(
                  classes: 'form-control mb-4 flex flex-row items-center gap-3',
                  [
                    p(
                      classes: 'text-[14px] font-semibold text-gray-500',
                      [.text('Active')],
                    ),
                    input(
                      type: InputType.checkbox,
                      classes:
                          'toggle ${_isActive ? 'toggle-success' : ''} hover:cursor-pointer',
                      checked: _isActive,
                      events: {
                        'change': (e) {
                          final target = e.target as web.HTMLInputElement;
                          setState(() {
                            _isActive = target.checked;
                          });
                        },
                      },
                    ),
                  ],
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
