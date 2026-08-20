import 'package:flutter/material.dart';

/// Header widget displaying product name and current inventory cleanly without gray box.
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Current Inventory', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        Text('$currentQuantity units', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
      ],
    );
  }
}
