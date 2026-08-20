import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/modal_switch.dart';

/// Stock monitoring toggle and low stock threshold configuration fields without gray boxes.
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
    return Column(
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
                  Gap(2),
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
          const Gap(14),
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
    );
  }
}
