import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class UpdateStockModal extends StatefulComponent {
  const UpdateStockModal({super.key, required this.product});

  final Product product;

  @override
  State<UpdateStockModal> createState() => _UpdateStockModalState();
}

class _UpdateStockModalState extends State<UpdateStockModal> {
  late StockTransactionType _transactionType;
  late String _amount;
  late StockTransactionReason _reason;
  late String _customReason;
  late String _lowStockThreshold;
  late bool _stockMonitor;

  @override
  void initState() {
    super.initState();
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      final s = component.product.stock;
      _transactionType = .add;
      _amount = '1';
      _reason = .adjustment;
      _customReason = '';
      _lowStockThreshold = s != null ? '${s.lowStockThreshold}' : '5';
      _stockMonitor = s?.stockMonitor ?? true;
    });
  }

  void _onSubmit(Event e) {
    e.preventDefault();

    final inputAmount = int.tryParse(_amount.trim());
    final lowStockThreshold = int.tryParse(_lowStockThreshold.trim());
    final currentQty = component.product.stock?.quantity ?? 0;

    if (inputAmount == null || inputAmount < 0) {
      showToast('Please enter a valid non-negative quantity.');
      return;
    }

    if (_stockMonitor && lowStockThreshold == null) {
      showToast(
        'Low Stock Threshold is required when Stock Monitor is enabled.',
      );
      return;
    }

    final computedFinalQuantity = switch (_transactionType) {
      .add => currentQty + inputAmount,
      .reduce => (currentQty - inputAmount).clamp(0, 999999),
      .set => inputAmount,
    };

    activeModalSignal.value = .none;

    if (component.product.stock != null) {
      ProductsActions.updateStock(
        stockId: component.product.stock!.id,
        productId: component.product.id,
        quantity: computedFinalQuantity,
        lowStockThreshold: lowStockThreshold,
        stockMonitor: _stockMonitor,
        transactionType: _transactionType,
        amount: inputAmount,
        reason: _transactionType == .add ? .restock : _reason,
        customReason:
            _transactionType != .add && _customReason.trim().isNotEmpty
            ? _customReason.trim()
            : null,
      );
    }
  }

  @override
  Component build(BuildContext context) {
    final currentQty = component.product.stock?.quantity ?? 0;

    return Modal(
      title: 'Update Stock - ${component.product.name}',
      child: form(
        method: .post,
        events: {'submit': (e) => _onSubmit(e)},
        [
          // Current Stock Info Banner
          div(
            classes:
                'flex items-center justify-between p-3 mb-4 rounded-xl bg-neutral/40 border border-border-medium',
            [
              span(classes: 'text-xs text-gray-500 font-medium', [
                .text('Current Inventory'),
              ]),
              span(classes: 'text-sm font-bold text-primary', [
                .text('$currentQty units'),
              ]),
            ],
          ),

          // Stock Operation Radio Selector
          div(classes: 'flex flex-col gap-1.5 mb-4', [
            label(classes: 'text-[14px] font-semibold text-gray-700', [
              .text('Stock Action'),
            ]),
            div(classes: 'grid grid-cols-3 gap-2', [
              operationButton(
                label: 'Add Stock (+)',
                value: .add,
                colorClass: _transactionType == .add
                    ? 'bg-emerald-600 text-white font-bold'
                    : 'bg-white border border-border-medium hover:bg-neutral text-gray-700',
              ),
              operationButton(
                label: 'Reduce (-)',
                value: .reduce,
                colorClass: _transactionType == .reduce
                    ? 'bg-rose-600 text-white font-bold'
                    : 'bg-white border border-border-medium hover:bg-neutral text-gray-700',
              ),
              operationButton(
                label: 'Set Exact (=)',
                value: .set,
                colorClass: _transactionType == .set
                    ? 'bg-primary text-white font-bold'
                    : 'bg-white border border-border-medium hover:bg-neutral text-gray-700',
              ),
            ]),
          ]),

          // Quantity Input
          FormField(
            id: 'amount',
            labelText: switch (_transactionType) {
              .add => 'Quantity to Add',
              .reduce => 'Quantity to Reduce',
              .set => 'New Stock Count',
            },
            type: .number,
            attributes: {
              'placeholder': '1',
              'required': '',
              'min': '0',
              'value': _amount,
            },
            hintText: 'Enter a valid quantity.',
            onChange: (value) => _amount = value as String,
          ),

          // Reason Section (only for Reduce / Set Exact stock)
          if (_transactionType != .add) ...[
            div(classes: 'flex flex-col gap-1.5 mb-4', [
              label(classes: 'text-[14px] font-semibold text-gray-700', [
                .text('Reason for Adjustment'),
              ]),
              select(
                classes:
                    'select select-bordered w-full rounded-xl text-sm border-border-medium focus:outline-hidden',
                events: {
                  'change': (e) {
                    final target = e.target as HTMLSelectElement;
                    setState(() {
                      _reason = StockTransactionReason.values.byName(
                        target.value,
                      );
                    });
                  },
                },
                [
                  option(
                    value: StockTransactionReason.adjustment.name,
                    selected: _reason == .adjustment,
                    [.text('Inventory Adjustment / Audit')],
                  ),
                  option(
                    value: StockTransactionReason.wastage.name,
                    selected: _reason == .wastage,
                    [.text('Wastage / Damaged Goods')],
                  ),
                ],
              ),
              if (_reason == .wastage)
                p(classes: 'text-xs text-rose-500 font-medium mt-1', [
                  .text(
                    '⚠️ Wasted items will be recorded as inventory loss in Profit & Loss report.',
                  ),
                ]),
            ]),

            // Optional Reason Description Input Field
            FormField(
              id: 'customReason',
              labelText: 'Reason Description',
              type: .text,
              attributes: {
                'placeholder':
                    'e.g. Expired on 04/08, Damaged in shipping (Optional)',
                'value': _customReason,
              },
              hintText: 'Optional description or note.',
              onChange: (value) => _customReason = value as String,
            ),
          ],

          // Stock Monitor Toggle
          div(
            classes:
                'form-control mb-4 flex flex-row items-center justify-between p-3 rounded-xl bg-neutral/20 border border-border-medium',
            [
              div(classes: 'flex flex-col', [
                span(classes: 'text-sm font-semibold text-gray-700', [
                  .text('Stock Monitor'),
                ]),
                span(classes: 'text-xs text-gray-500', [
                  .text('Receive low stock alerts'),
                ]),
              ]),
              input(
                type: .checkbox,
                classes:
                    'toggle ${_stockMonitor ? 'toggle-success' : ''} hover:cursor-pointer',
                checked: _stockMonitor,
                events: {
                  'change': (e) {
                    final target = e.target as HTMLInputElement;
                    setState(() {
                      _stockMonitor = target.checked;
                    });
                  },
                },
              ),
            ],
          ),

          if (_stockMonitor)
            FormField(
              id: 'lowStockThreshold',
              labelText: 'Low Stock Threshold',
              type: .number,
              attributes: {
                'placeholder': '5',
                'required': '',
                'min': '0',
                'value': _lowStockThreshold,
              },
              hintText: 'Low stock threshold is required.',
              onChange: (value) => _lowStockThreshold = value as String,
            ),

          // Form Actions Footer (Reset + Cancel + Save)
          div(classes: 'flex justify-between items-center pt-3 gap-2', [
            button(
              type: .button,
              classes:
                  'btn btn-sm rounded-lg border border-border-medium bg-white hover:bg-rose-50 hover:text-rose-600 hover:border-rose-300 text-xs font-medium text-gray-600 transition-all duration-200 hover:cursor-pointer',
              events: {'click': (e) => _resetForm()},
              [
                .text('Reset'),
              ],
            ),
            div(classes: 'flex items-center gap-2', [
              button(
                type: .button,
                classes:
                    'btn btn-sm rounded-lg border border-border-medium bg-white hover:bg-neutral text-xs font-medium text-gray-600 hover:cursor-pointer',
                events: {
                  'click': (e) => activeModalSignal.value = .none,
                },
                [
                  .text('Cancel'),
                ],
              ),
              button(
                type: .submit,
                classes:
                    'bg-primary text-primary-content px-5 h-9 rounded-lg hover:cursor-pointer hover:bg-opacity-80 transition-all duration-300 text-xs font-semibold',
                [
                  .text('Save Changes'),
                ],
              ),
            ]),
          ]),
        ],
      ),
    );
  }

  button operationButton({
    required String label,
    required StockTransactionType value,
    required String colorClass,
  }) {
    return button(
      type: .button,
      classes:
          'h-9 rounded-lg text-xs font-medium transition-all cursor-pointer $colorClass',
      events: {
        'click': (e) {
          setState(() {
            _transactionType = value;
            _reason = switch (value) {
              .reduce => .wastage,
              .add || .set => .adjustment,
            };
          });
        },
      },
      [
        .text(label),
      ],
    );
  }
}
