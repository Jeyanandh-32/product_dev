import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/modal_select_field.dart';

/// Reason selection section for stock reduction or override adjustments.
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
          items: StockTransactionReason.values.map((r) {
            final label = r.name[0].toUpperCase() + r.name.substring(1);
            return (label: label, value: r);
          }).toList(),
          onChanged: (val) {
            if (val != null) onReasonChanged(val);
          },
        ),
        if (reason == StockTransactionReason.adjustment || reason == StockTransactionReason.wastage) ...[
          const Gap(12),
          ModalInputField(
            label: 'Custom Notes (Optional)',
            hint: 'e.g. Broken in transit, expired batch...',
            value: customReason,
            onChanged: onCustomReasonChanged,
          ),
        ],
      ],
    );
  }
}
