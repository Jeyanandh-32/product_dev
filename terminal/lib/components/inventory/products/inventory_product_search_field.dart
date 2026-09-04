import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:terminal/signals/inventory_products_signal.dart';

/// Clean inventory search input box with clear action.
class InventoryProductSearchField extends StatefulWidget {
  final double? width;

  const InventoryProductSearchField({super.key, this.width});

  @override
  State<InventoryProductSearchField> createState() =>
      _InventoryProductSearchFieldState();
}

class _InventoryProductSearchFieldState
    extends State<InventoryProductSearchField> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
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
                inventorySearchSignal.value = val;
                inventoryPageSignal.value = 1;
                setState(() {});
              },
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
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
                inventorySearchSignal.value = '';
                inventoryPageSignal.value = 1;
                setState(() {});
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(FLucideIcons.x, size: 14, color: Color(0xFF94A3B8)),
              ),
            ),
        ],
      ),
    );

    return widget.width != null
        ? SizedBox(width: widget.width, child: box)
        : box;
  }
}
