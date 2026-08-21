import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/components/modals/stock_action_selector.dart';
import 'package:merchant/components/modals/stock_monitor_settings_section.dart';
import 'package:merchant/components/modals/stock_reason_section.dart';
import 'package:merchant/components/modals/update_stock_handler.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Modal dialog for managing and adjusting product inventory levels.
class UpdateStockModal extends StatefulComponent {
  const UpdateStockModal({super.key, required this.product});

  final Product product;

  @override
  State<UpdateStockModal> createState() => _UpdateStockModalState();
}

class _UpdateStockModalState extends State<UpdateStockModal> {
  StockTransactionType _transactionType = .add;
  String _amount = '';
  StockTransactionReason _reason = .adjustment;
  String _customReason = '';
  String _lowStockThreshold = '5';
  bool _stockMonitor = true;

  @override
  void initState() {
    super.initState();
    final s = component.product.stock;
    if (s != null) {
      _lowStockThreshold = '${s.lowStockThreshold}';
      _stockMonitor = s.stockMonitor;
    }
  }

  void _onTypeChanged(StockTransactionType t) {
    setState(() {
      _transactionType = t;
      _reason = StockTransactionReason.adjustment;
    });
  }

  void _onSubmit(web.Event e) {
    e.preventDefault();
    UpdateStockHandler.submitStockUpdate(
      product: component.product,
      transactionType: _transactionType,
      amountStr: _amount,
      lowStockThresholdStr: _lowStockThreshold,
      stockMonitor: _stockMonitor,
      reason: _reason,
      customReason: _customReason,
    );
  }

  @override
  Component build(BuildContext context) {
    final currentQty = component.product.stock?.quantity ?? 0;
    final parsed = int.tryParse(_amount.trim());
    final isAdjustment = parsed != null && parsed > 0;
    final isReduction = isAdjustment && (_transactionType == StockTransactionType.reduce || (_transactionType == StockTransactionType.set && parsed < currentQty));

    return Modal(
      title: 'Update Stock - ${component.product.name}',
      child: form(
        events: {'submit': _onSubmit},
        [
          div(
            classes: 'mb-4 p-3 rounded-xl bg-neutral/20 border border-border-medium flex justify-between items-center',
            [
              span(classes: 'text-sm font-medium text-gray-600', [.text('Current Inventory:')]),
              span(classes: 'text-lg font-bold text-gray-900', [.text('$currentQty units')]),
            ],
          ),
          StockActionSelector(selectedType: _transactionType, onTypeChanged: _onTypeChanged),
          FormField(
            id: 'amount',
            labelText: switch (_transactionType) {
              .add => 'Quantity to Add (Optional)',
              .reduce => 'Quantity to Reduce (Optional)',
              .set => 'Set Exact Total Quantity (Optional)',
            },
            type: InputType.number,
            attributes: {
              'placeholder': 'Leave empty to keep $currentQty units',
              'min': '0',
              'value': _amount,
            },
            hintText: 'Leave empty or 0 to update alerts and monitoring settings only.',
            onChange: (value) => setState(() => _amount = value.toString()),
          ),
          if (isReduction)
            StockReasonSection(
              reason: _reason,
              customReason: _customReason,
              onReasonChanged: (r) => setState(() => _reason = r),
              onCustomReasonChanged: (val) => _customReason = val,
            ),
          StockMonitorSettingsSection(
            stockMonitor: _stockMonitor,
            lowStockThreshold: _lowStockThreshold,
            onToggleMonitor: (val) => setState(() => _stockMonitor = val),
            onThresholdChanged: (val) => _lowStockThreshold = val,
          ),
          div(
            classes: 'flex justify-end gap-3 pt-4 border-t border-border-light',
            [
              button(
                type: ButtonType.button,
                classes: 'btn btn-ghost border border-border-medium px-5 rounded-xl hover:bg-neutral text-gray-700 font-medium',
                events: {'click': (e) => activeModalSignal.value = ActiveModal.none},
                [.text('Cancel')],
              ),
              button(
                type: ButtonType.submit,
                classes: 'btn bg-primary hover:bg-primary/90 text-white font-bold px-6 rounded-xl shadow-xs border-0 cursor-pointer',
                [.text('Save Changes')],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
