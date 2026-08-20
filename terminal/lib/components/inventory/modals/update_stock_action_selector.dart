import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';

/// Segmented action selector for stock transaction operations matching Merchant layout & sizes.
class UpdateStockActionSelector extends StatelessWidget {
  final StockTransactionType selectedType;
  final ValueChanged<StockTransactionType> onTypeChanged;

  const UpdateStockActionSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stock Action',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const Gap(8),
        Row(
          children: [
            _buildButton('Add Stock (+)', StockTransactionType.add),
            const Gap(8),
            _buildButton('Reduce (-)', StockTransactionType.reduce),
            const Gap(8),
            _buildButton('Set Exact (=)', StockTransactionType.set),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String label, StockTransactionType type) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTypeChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF000000) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}
