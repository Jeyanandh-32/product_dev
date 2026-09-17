import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/inventory_dropdown_filter.dart';
import 'package:terminal/signals/inventory_counters_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Top control toolbar for Inventory Counters with search box and status filter (read-only for POS terminals).
class InventoryCountersToolbar extends StatefulWidget {
  const InventoryCountersToolbar({super.key});

  @override
  State<InventoryCountersToolbar> createState() => _InventoryCountersToolbarState();
}

class _InventoryCountersToolbarState extends State<InventoryCountersToolbar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return SignalBuilder(builder: (context) {
      final statusFilter = InventoryDropdownFilter<bool>(
        label: 'Status',
        value: counterStatusFilterSignal.value,
        items: const [(label: 'All Status', value: null), (label: 'Active', value: true), (label: 'Inactive', value: false)],
        onSelected: (val) {
          counterStatusFilterSignal.value = val;
          counterPageSignal.value = 1;
        },
      );

      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchBox(),
            const Gap(10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [statusFilter],
            ),
          ],
        );
      }

      return Row(
        children: [
          statusFilter,
          const Spacer(),
          _buildSearchBox(width: 260),
        ],
      );
    });
  }

  Widget _buildSearchBox({double? width}) {
    final box = Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), offset: Offset(0, 1), blurRadius: 2)],
      ),
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: Row(
        children: [
          const Icon(FLucideIcons.search, size: 14.5, color: Color(0xFF64748B)),
          const Gap(8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                counterSearchSignal.value = val;
                counterPageSignal.value = 1;
                setState(() {});
              },
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                hintText: 'Search counters...',
                hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                counterSearchSignal.value = '';
                counterPageSignal.value = 1;
                setState(() {});
              },
              child: const MouseRegion(cursor: SystemMouseCursors.click, child: Icon(FLucideIcons.x, size: 14, color: Color(0xFF94A3B8))),
            ),
        ],
      ),
    );
    if (width != null) return SizedBox(width: width, child: box);
    return box;
  }
}
