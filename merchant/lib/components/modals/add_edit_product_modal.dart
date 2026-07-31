import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/categories_provider.dart';
import 'package:merchant/providers/counters_provider.dart';
import 'package:merchant/providers/products_provider.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class AddEditProductModal extends StatefulComponent {
  const AddEditProductModal({super.key, this.product});

  final Product? product;

  @override
  State<AddEditProductModal> createState() => _AddEditProductModalState();
}

class _AddEditProductModalState extends State<AddEditProductModal> {
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
  }

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();

    if (_categoryId.isEmpty) {
      context.read(toastProvider.notifier).state = 'Category is required.';
      Future.delayed(const Duration(seconds: 3), () {
        context.read(toastProvider.notifier).state = null;
      });
      return;
    }
    if (_counterId.isEmpty) {
      context.read(toastProvider.notifier).state = 'Counter is required.';
      Future.delayed(const Duration(seconds: 3), () {
        context.read(toastProvider.notifier).state = null;
      });
      return;
    }

    context.read(activeModalProvider.notifier).state = ActiveModal.none;

    final basePrice = double.tryParse(_basePrice.trim()) ?? 0.0;
    final sellingPrice = double.tryParse(_sellingPrice.trim()) ?? 0.0;
    final taxRate = double.tryParse(_taxRate.trim()) ?? 0.0;

    if (component.product != null) {
      context
          .read(productsProvider.notifier)
          .updateProduct(
            id: component.product!.id,
            name: _name.trim(),
            categoryId: _categoryId,
            counterId: _counterId,
            basePrice: basePrice,
            sellingPrice: sellingPrice,
            taxRate: taxRate,
            isActive: _isActive,
            sku: _sku.trim().isEmpty ? null : _sku.trim(),
            barcode: _barcode.trim().isEmpty ? null : _barcode.trim(),
            imageUrl: _imageUrl.trim().isEmpty ? null : _imageUrl.trim(),
          );
    } else {
      context
          .read(productsProvider.notifier)
          .create(
            name: _name.trim(),
            categoryId: _categoryId,
            counterId: _counterId,
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
  Component build(BuildContext context) {
    final categories = context.watch(categoriesProvider).value ?? [];
    final counters = context.watch(countersProvider).value ?? [];

    return Modal(
      title: component.product != null ? 'Edit Product' : 'Add Product',
      child: form(
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(context, e)},
        [
          div(
            classes:
                'max-h-[60vh] overflow-y-auto overflow-x-hidden flex flex-col gap-0 px-3',
            [
              // Name
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

              // Category & Counter dropdowns stacked vertically
              // Category dropdown
              fieldset(classes: 'fieldset w-full mb-4', [
                label(
                  htmlFor: 'categoryId',
                  classes: 'label text-[14px] font-semibold text-gray-500',
                  [.text('Category')],
                ),
                div(classes: 'dropdown w-full', [
                  div(
                    classes:
                        'btn border border-border-medium bg-white hover:bg-base-200 text-sm h-11 w-full justify-between font-normal px-3 rounded-lg ${_categoryId.isEmpty ? 'text-gray-400' : 'text-base-content'}',
                    attributes: {
                      'tabindex': '0',
                      'role': 'button',
                    },
                    [
                      span([
                        .text(
                          _categoryId.isEmpty
                              ? 'Select Category'
                              : (categories.any((c) => c.id == _categoryId)
                                    ? categories
                                          .firstWhere(
                                            (c) => c.id == _categoryId,
                                          )
                                          .name
                                    : 'Select Category'),
                        ),
                      ]),
                      ChevronDown(classes: 'w-4 h-4 opacity-50'),
                    ],
                  ),
                  ul(
                    attributes: {'tabindex': '-1'},
                    classes:
                        'dropdown-content menu bg-base-100 rounded-box z-50 mt-1 p-2 shadow-sm border border-border-light w-full max-h-48 overflow-y-auto',
                    [
                      for (final cat in categories)
                        li([
                          a(
                            href: '#',
                            classes:
                                'rounded-md hover:bg-neutral py-2 px-3 block ${cat.id == _categoryId ? 'bg-neutral font-semibold' : ''}',
                            onClick: () {
                              setState(() {
                                _categoryId = cat.id;
                              });
                              final activeElement = document.activeElement;
                              if (activeElement != null) {
                                (activeElement as HTMLElement).blur();
                              }
                            },
                            [.text(cat.name)],
                          ),
                        ]),
                    ],
                  ),
                ]),
              ]),

              // Counter dropdown
              fieldset(classes: 'fieldset w-full mb-4', [
                label(
                  htmlFor: 'counterId',
                  classes: 'label text-[14px] font-semibold text-gray-500',
                  [.text('Counter')],
                ),
                div(classes: 'dropdown w-full', [
                  div(
                    classes:
                        'btn border border-border-medium bg-white hover:bg-base-200 text-sm h-11 w-full justify-between font-normal px-3 rounded-lg ${_counterId.isEmpty ? 'text-gray-400' : 'text-base-content'}',
                    attributes: {
                      'tabindex': '0',
                      'role': 'button',
                    },
                    [
                      span([
                        .text(
                          _counterId.isEmpty
                              ? 'Select Counter'
                              : (counters.any((c) => c.id == _counterId)
                                    ? counters
                                          .firstWhere((c) => c.id == _counterId)
                                          .name
                                    : 'Select Counter'),
                        ),
                      ]),
                      ChevronDown(classes: 'w-4 h-4 opacity-50'),
                    ],
                  ),
                  ul(
                    attributes: {'tabindex': '-1'},
                    classes:
                        'dropdown-content menu bg-base-100 rounded-box z-50 mt-1 p-2 shadow-sm border border-border-light w-full max-h-48 overflow-y-auto',
                    [
                      for (final cnt in counters)
                        li([
                          a(
                            href: '#',
                            classes:
                                'rounded-md hover:bg-neutral py-2 px-3 block ${cnt.id == _counterId ? 'bg-neutral font-semibold' : ''}',
                            onClick: () {
                              setState(() {
                                _counterId = cnt.id;
                              });
                              final activeElement = document.activeElement;
                              if (activeElement != null) {
                                (activeElement as HTMLElement).blur();
                              }
                            },
                            [.text(cnt.name)],
                          ),
                        ]),
                    ],
                  ),
                ]),
              ]),

              // Base Price & Selling Price side by side
              div(classes: 'flex gap-4', [
                FormField(
                  id: 'basePrice',
                  labelText: 'Base Price (₹)',
                  type: InputType.number,
                  attributes: {
                    'placeholder': '100',
                    'required': '',
                    'min': '0',
                    'value': _basePrice,
                  },
                  hintText: 'Base price is required.',
                  onChange: (value) => _basePrice = value as String,
                ),
                FormField(
                  id: 'sellingPrice',
                  labelText: 'Selling Price (₹)',
                  type: InputType.number,
                  attributes: {
                    'placeholder': '120',
                    'required': '',
                    'min': '0',
                    'value': _sellingPrice,
                  },
                  hintText: 'Selling price is required.',
                  onChange: (value) => _sellingPrice = value as String,
                ),
              ]),

              // Tax Rate
              FormField(
                id: 'taxRate',
                labelText: 'Tax Rate (%)',
                type: InputType.number,
                attributes: {
                  'placeholder': '0',
                  'min': '0',
                  'max': '100',
                  'step': '0.01',
                  'value': _taxRate,
                },
                onChange: (value) => _taxRate = value as String,
              ),

              // SKU & Barcode stacked vertically
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

              // Image URL
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

              // Active toggle (edit only)
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
                          final target = e.target as HTMLInputElement;
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

          // Submit button
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
