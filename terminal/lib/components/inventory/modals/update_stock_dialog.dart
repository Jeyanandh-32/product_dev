import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/update_stock_action_selector.dart';
import 'package:terminal/components/inventory/modals/update_stock_actions.dart';
import 'package:terminal/components/inventory/modals/update_stock_header.dart';
import 'package:terminal/components/inventory/modals/update_stock_monitor_section.dart';
import 'package:terminal/components/inventory/modals/update_stock_reason_section.dart';
import 'package:terminal/signals/inventory_stock_actions.dart';

/// Modal dialog for updating stock levels, adjustments, and monitoring thresholds.
class UpdateStockDialog extends StatefulWidget {
  final Product product;
  const UpdateStockDialog({super.key, required this.product});

  @override
  State<UpdateStockDialog> createState() => _UpdateStockDialogState();
}

class _UpdateStockDialogState extends State<UpdateStockDialog> {
  StockTransactionType _type = StockTransactionType.add;
  String _amount = '1';
  StockTransactionReason _reason = StockTransactionReason.adjustment;
  String _customReason = '';
  late bool _monitor = widget.product.stock?.stockMonitor ?? true;
  late String _lowThreshold = '${widget.product.stock?.lowStockThreshold ?? 5}';
  bool _isSubmitting = false;

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
    final isRed = _type != StockTransactionType.add;
    final label = switch (_type) {
      StockTransactionType.add => 'Quantity to Add',
      StockTransactionType.reduce => 'Quantity to Reduce',
      StockTransactionType.set => 'Set Exact Quantity',
    };
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE2E8F0))),
      backgroundColor: const Color(0xFFFFFFFF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 460, maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Update Stock • ${widget.product.name}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis)),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UpdateStockHeader(productName: widget.product.name, currentQuantity: widget.product.stock?.quantity ?? 0),
                      const Gap(14),
                      UpdateStockActionSelector(selectedType: _type, onTypeChanged: (t) => setState(() => _type = t)),
                      const Gap(14),
                      ModalInputField(label: label, hint: '1', value: _amount, isRequired: true, keyboardType: TextInputType.number, onChanged: (v) => _amount = v),
                      if (isRed) ...[
                        const Gap(14),
                        UpdateStockReasonSection(reason: _reason, customReason: _customReason, onReasonChanged: (r) => setState(() => _reason = r), onCustomReasonChanged: (v) => _customReason = v),
                      ],
                      const Gap(14),
                      UpdateStockMonitorSection(stockMonitor: _monitor, lowStockThreshold: _lowThreshold, onToggleMonitor: (m) => setState(() => _monitor = m), onThresholdChanged: (v) => _lowThreshold = v),
                    ],
                  ),
                ),
              ),
              const Gap(18),
              UpdateStockActions(isSubmitting: _isSubmitting, onSubmit: _handleSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
