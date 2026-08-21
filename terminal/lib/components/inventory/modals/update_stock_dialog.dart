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
import 'package:terminal/utils/terminal_toast.dart';

/// Modal dialog for updating stock levels, adjustments, and monitoring thresholds.
class UpdateStockDialog extends StatefulWidget {
  final Product product;
  const UpdateStockDialog({super.key, required this.product});

  @override
  State<UpdateStockDialog> createState() => _UpdateStockDialogState();
}

class _UpdateStockDialogState extends State<UpdateStockDialog> {
  StockTransactionType _type = StockTransactionType.add;
  String _amount = '';
  StockTransactionReason _reason = StockTransactionReason.adjustment;
  String _customReason = '';
  late bool _monitor = widget.product.stock?.stockMonitor ?? true;
  late String _lowThreshold = '${widget.product.stock?.lowStockThreshold ?? 5}';
  bool _isSubmitting = false;

  void _onTypeChanged(StockTransactionType t) => setState(() {
    _type = t;
    _reason = StockTransactionReason.adjustment;
  });

  Future<void> _handleSubmit() async {
    final amountTrimmed = _amount.trim();
    final lowStockThreshold = int.tryParse(_lowThreshold.trim());
    final currentQty = widget.product.stock?.quantity ?? 0;
    final stockId = widget.product.stock?.id;
    if (stockId == null) return;

    if (_monitor && lowStockThreshold == null) {
      TerminalToast.showError(context: context, title: 'Validation Error', description: 'Low stock limit is required when monitoring is enabled.');
      return;
    }
    final int? inputAmount = amountTrimmed.isEmpty ? null : int.tryParse(amountTrimmed);
    if (amountTrimmed.isNotEmpty && (inputAmount == null || inputAmount < 0)) {
      TerminalToast.showError(context: context, title: 'Invalid Quantity', description: 'Please enter a valid non-negative quantity.');
      return;
    }
    final isAdjustment = inputAmount != null;
    if (isAdjustment && _type == StockTransactionType.reduce) {
      if (currentQty <= 0) {
        TerminalToast.showError(context: context, title: 'Invalid Action', description: 'Cannot reduce stock because current inventory is 0 units.');
        return;
      }
      if (inputAmount > currentQty) {
        TerminalToast.showError(context: context, title: 'Invalid Quantity', description: 'Cannot reduce $inputAmount units. Maximum available is $currentQty units.');
        return;
      }
    }
    final finalQty = isAdjustment ? switch (_type) {
      StockTransactionType.add => currentQty + inputAmount,
      StockTransactionType.reduce => (currentQty - inputAmount).clamp(0, 999999),
      StockTransactionType.set => inputAmount,
    } : null;

    final isReduction = isAdjustment && (_type == StockTransactionType.reduce || (_type == StockTransactionType.set && (finalQty ?? currentQty) < currentQty));
    final effectiveReason = isReduction ? _reason : StockTransactionReason.restock;

    setState(() => _isSubmitting = true);
    try {
      await InventoryStockActions.updateStock(
        stockId: stockId, productId: widget.product.id, quantity: finalQty,
        lowStockThreshold: _monitor ? lowStockThreshold : null, stockMonitor: _monitor,
        transactionType: isAdjustment ? _type : null, amount: inputAmount, reason: isAdjustment ? effectiveReason : null,
        customReason: isReduction && _customReason.trim().isNotEmpty ? _customReason.trim() : null,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      TerminalToast.showSuccess(
        context: context, title: isAdjustment ? 'Stock Updated' : 'Settings Saved',
        description: isAdjustment ? '${widget.product.name} stock is now $finalQty units.' : 'Monitoring settings updated for ${widget.product.name}.',
      );
    } catch (e) {
      if (!mounted) return;
      TerminalToast.showError(context: context, title: 'Update Failed', description: e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQty = widget.product.stock?.quantity ?? 0;
    final parsed = int.tryParse(_amount.trim());
    final isAdjustment = parsed != null && parsed > 0;
    final isReduction = isAdjustment && (_type == StockTransactionType.reduce || (_type == StockTransactionType.set && parsed < currentQty));
    final label = switch (_type) {
      StockTransactionType.add => 'Quantity to Add (Optional)',
      StockTransactionType.reduce => 'Quantity to Reduce (Optional)',
      StockTransactionType.set => 'Set Exact Quantity (Optional)',
    };

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE2E8F0))),
      backgroundColor: const Color(0xFFFFFFFF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 460, maxHeight: MediaQuery.sizeOf(context).height * 0.88),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(child: Text('Update Stock • ${widget.product.name}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis)),
              MouseRegion(cursor: SystemMouseCursors.click, child: PressableBox(onPress: () => Navigator.of(context).pop(), style: BoxStyler().width(32).height(32).borderRadiusAll(const Radius.circular(999)).borderAll(color: const Color(0xFFE2E8F0)).color(const Color(0xFFFFFFFF)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFF8FAFC))), child: const Icon(FLucideIcons.x, size: 16, color: Color(0xFF64748B)))),
            ]),
            const Gap(16),
            Flexible(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              UpdateStockHeader(productName: widget.product.name, currentQuantity: currentQty),
              const Gap(14),
              UpdateStockActionSelector(selectedType: _type, onTypeChanged: _onTypeChanged),
              const Gap(14),
              ModalInputField(label: label, hint: 'Leave empty to keep $currentQty units', value: _amount, isRequired: false, keyboardType: TextInputType.number, onChanged: (v) => setState(() => _amount = v)),
              if (isReduction) ...[
                const Gap(14),
                UpdateStockReasonSection(reason: _reason, customReason: _customReason, onReasonChanged: (r) => setState(() => _reason = r), onCustomReasonChanged: (v) => _customReason = v),
              ],
              const Gap(14),
              UpdateStockMonitorSection(stockMonitor: _monitor, lowStockThreshold: _lowThreshold, onToggleMonitor: (m) => setState(() => _monitor = m), onThresholdChanged: (v) => _lowThreshold = v),
            ]))),
            const Gap(18),
            UpdateStockActions(isSubmitting: _isSubmitting, onSubmit: _handleSubmit),
          ]),
        ),
      ),
    );
  }
}
