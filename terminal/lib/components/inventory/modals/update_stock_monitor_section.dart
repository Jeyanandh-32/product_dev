import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/modal_switch.dart';

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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
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
                    Text('Stock Monitoring', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    Text('Receive low stock alerts in POS', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Gap(8),
              ModalSwitch(
                value: stockMonitor,
                onChanged: onToggleMonitor,
              ),
            ],
          ),
          if (stockMonitor) ...[
            const Gap(12),
            ModalInputField(
              label: 'Low Stock Alert Threshold',
              hint: '5',
              value: lowStockThreshold,
              isRequired: true,
              keyboardType: TextInputType.number,
              onChanged: onThresholdChanged,
            ),
          ],
        ],
      ),
    );
  }
}
