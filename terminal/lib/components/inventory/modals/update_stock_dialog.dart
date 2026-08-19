import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/update_stock_action_selector.dart';
import 'package:terminal/components/inventory/modals/update_stock_actions.dart';
import 'package:terminal/components/inventory/modals/update_stock_header.dart';
import 'package:terminal/components/inventory/modals/update_stock_monitor_section.dart';
import 'package:terminal/components/inventory/modals/update_stock_reason_section.dart';
import 'package:terminal/signals/inventory_products_signal.dart';

/// Modal dialog for updating product inventory quantity and monitoring settings.
class UpdateStockDialog extends StatefulWidget {
  final Product product;

  const UpdateStockDialog({super.key, required this.product});

  @override
  State<UpdateStockDialog> createState() => _UpdateStockDialogState();
}

class _UpdateStockDialogState extends State<UpdateStockDialog> {
  late StockTransactionType _type;
  late String _amount;
  late StockTransactionReason _reason;
  late String _customReason;
  late String _lowThreshold;
  late bool _monitor;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final stock = widget.product.stock;
    _type = StockTransactionType.add;
    _amount = '1';
    _reason = StockTransactionReason.adjustment;
    _customReason = '';
    _lowThreshold = stock != null ? '${stock.lowStockThreshold}' : '5';
    _monitor = stock?.stockMonitor ?? true;
  }

  Future<void> _handleSubmit() async {
    final inputAmount = int.tryParse(_amount.trim());
    final lowStockThreshold = int.tryParse(_lowThreshold.trim());
    final currentQty = widget.product.stock?.quantity ?? 0;

    if (inputAmount == null || inputAmount < 0) {
      showFToast(context: context, alignment: .topCenter, title: const Text('Invalid Quantity'), description: const Text('Please enter a valid non-negative quantity.'));
      return;
    }
    if (_monitor && lowStockThreshold == null) {
      showFToast(context: context, alignment: .topCenter, title: const Text('Validation Error'), description: const Text('Low stock limit is required when monitoring is enabled.'));
      return;
    }

    final finalQty = switch (_type) {
      StockTransactionType.add => currentQty + inputAmount,
      StockTransactionType.reduce => (currentQty - inputAmount).clamp(0, 999999),
      StockTransactionType.set => inputAmount,
    };
    final isReduction = _type == StockTransactionType.reduce || _type == StockTransactionType.set;
    final stockId = widget.product.stock?.id;
    if (stockId == null) return;

    setState(() => _isSubmitting = true);
    try {
      await InventoryStockActions.updateStock(
        stockId: stockId,
        productId: widget.product.id,
        quantity: finalQty,
        lowStockThreshold: _monitor ? lowStockThreshold : null,
        stockMonitor: _monitor,
        transactionType: _type,
        amount: inputAmount,
        reason: isReduction ? _reason : null,
        customReason: isReduction && _customReason.trim().isNotEmpty ? _customReason.trim() : null,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      showFToast(context: context, alignment: .topCenter, title: const Text('Stock Updated'), description: Text('${widget.product.name} stock is now $finalQty units.'));
    } catch (e) {
      if (!mounted) return;
      showFToast(context: context, alignment: .topCenter, title: const Text('Update Failed'), description: Text(e.toString()));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQty = widget.product.stock?.quantity ?? 0;
    final isReduction = _type == StockTransactionType.reduce || _type == StockTransactionType.set;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFFFFFFF),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UpdateStockHeader(productName: widget.product.name, currentQuantity: currentQty),
              const Gap(14),
              UpdateStockActionSelector(selectedType: _type, onTypeChanged: (t) => setState(() => _type = t)),
              const Gap(14),
              TextField(
                controller: TextEditingController(text: _amount)..selection = TextSelection.collapsed(offset: _amount.length),
                keyboardType: TextInputType.number,
                onChanged: (val) => _amount = val,
                decoration: InputDecoration(
                  labelText: switch (_type) {
                    StockTransactionType.add => 'Quantity to Add',
                    StockTransactionType.reduce => 'Quantity to Reduce',
                    StockTransactionType.set => 'Set Exact Total Quantity',
                  },
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (isReduction) ...[
                const Gap(14),
                UpdateStockReasonSection(reason: _reason, customReason: _customReason, onReasonChanged: (r) => setState(() => _reason = r), onCustomReasonChanged: (c) => _customReason = c),
              ],
              const Gap(14),
              UpdateStockMonitorSection(stockMonitor: _monitor, lowStockThreshold: _lowThreshold, onToggleMonitor: (m) => setState(() => _monitor = m), onThresholdChanged: (t) => _lowThreshold = t),
              const Gap(18),
              UpdateStockActions(isSubmitting: _isSubmitting, onSubmit: _handleSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
