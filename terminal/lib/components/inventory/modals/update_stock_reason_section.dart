import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/modal_select_field.dart';

/// Reason selection section for stock reduction matching Merchant options & warnings.
class UpdateStockReasonSection extends StatelessWidget {
  final StockTransactionReason reason;
  final String customReason;
  final ValueChanged<StockTransactionReason> onReasonChanged;
  final ValueChanged<String> onCustomReasonChanged;

  const UpdateStockReasonSection({
    super.key,
    required this.reason,
    required this.customReason,
    required this.onReasonChanged,
    required this.onCustomReasonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModalSelectField<StockTransactionReason>(
          label: 'Reason for Adjustment',
          value: reason,
          items: const [
            (label: 'Inventory Adjustment / Audit', value: StockTransactionReason.adjustment),
            (label: 'Wastage / Damaged Goods', value: StockTransactionReason.wastage),
          ],
          onChanged: (val) {
            if (val != null) onReasonChanged(val);
          },
        ),
        if (reason == StockTransactionReason.wastage) ...[
          const Gap(6),
          const Text(
            '⚠️ Wasted items will be recorded as inventory loss in Profit & Loss report.',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: Color(0xFFE11D48)),
          ),
        ],
        const Gap(14),
        ModalInputField(
          label: 'Reason Description (Optional)',
          hint: 'e.g. Expired on 04/08, Damaged in shipping (Optional)',
          value: customReason,
          onChanged: onCustomReasonChanged,
        ),
      ],
    );
  }
}
