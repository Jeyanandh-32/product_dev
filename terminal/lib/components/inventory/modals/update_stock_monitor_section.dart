import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Stock monitoring toggle and low stock threshold configuration fields.
class UpdateStockMonitorSection extends StatelessWidget {
  final bool stockMonitor;
  final String lowStockThreshold;
  final ValueChanged<bool> onToggleMonitor;
  final ValueChanged<String> onThresholdChanged;

  const UpdateStockMonitorSection({
    super.key,
    required this.stockMonitor,
    required this.lowStockThreshold,
    required this.onToggleMonitor,
    required this.onThresholdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stock Monitor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    Text('Trigger low stock warning alerts', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Gap(8),
              Switch.adaptive(
                value: stockMonitor,
                activeThumbColor: const Color(0xFF000000),
                onChanged: onToggleMonitor,
              ),
            ],
          ),
          if (stockMonitor) ...[
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Low Stock Alert Limit', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                SizedBox(
                  width: 80,
                  height: 32,
                  child: TextField(
                    controller: TextEditingController(text: lowStockThreshold)..selection = TextSelection.collapsed(offset: lowStockThreshold.length),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: onThresholdChanged,
                    decoration: InputDecoration(
                      hintText: '5',
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
