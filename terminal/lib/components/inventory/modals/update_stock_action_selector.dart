import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// Segmented action selector for stock transaction type.
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _buildSegment('Add (+)', StockTransactionType.add),
          _buildSegment('Reduce (-)', StockTransactionType.reduce),
          _buildSegment('Set (=)', StockTransactionType.set),
        ],
      ),
    );
  }

  Widget _buildSegment(String label, StockTransactionType type) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTypeChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF000000) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}
