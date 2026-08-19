import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Header widget displaying product name and current inventory box.
class UpdateStockHeader extends StatelessWidget {
  final String productName;
  final int currentQuantity;

  const UpdateStockHeader({
    super.key,
    required this.productName,
    required this.currentQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Stock • $productName',
          style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const Gap(14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Inventory:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
              Text('$currentQuantity units', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
            ],
          ),
        ),
      ],
    );
  }
}
