import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/modal_select_field.dart';

/// Reason selection section for stock reductions and audits matching Merchant design.
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

  static const List<({String label, StockTransactionReason value})> _items = [
    (label: 'Wastage / Damaged Goods', value: StockTransactionReason.wastage),
    (label: 'Inventory Adjustment / Shrinkage', value: StockTransactionReason.adjustment),
  ];

  @override
  Widget build(BuildContext context) {
    final validReason = _items.any((i) => i.value == reason) ? reason : _items.first.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModalSelectField<StockTransactionReason>(
          label: 'Reason for Reduction / Adjustment',
          value: validReason,
          items: _items,
          onChanged: (val) {
            if (val != null) onReasonChanged(val);
          },
        ),
        if (validReason == StockTransactionReason.wastage) ...[
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
