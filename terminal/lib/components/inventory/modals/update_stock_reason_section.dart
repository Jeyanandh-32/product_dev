import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reason for Adjustment',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
        ),
        const Gap(6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<StockTransactionReason>(
              value: reason,
              isExpanded: true,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              items: StockTransactionReason.values.map((r) {
                final label = r.name[0].toUpperCase() + r.name.substring(1);
                return DropdownMenuItem(value: r, child: Text(label));
              }).toList(),
              onChanged: (val) {
                if (val != null) onReasonChanged(val);
              },
            ),
          ),
        ),
        if (reason == StockTransactionReason.adjustment || reason == StockTransactionReason.wastage) ...[
          const Gap(8),
          TextField(
            controller: TextEditingController(text: customReason)..selection = TextSelection.collapsed(offset: customReason.length),
            onChanged: onCustomReasonChanged,
            decoration: InputDecoration(
              hintText: 'Add custom reason or notes...',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            ),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}
