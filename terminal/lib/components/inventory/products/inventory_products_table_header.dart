import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/inventory_products_signal.dart';

/// Pinned sticky header for POS products table matching DaisyUI thead (table-pin-rows).
class InventoryProductsTableHeader extends StatelessWidget {
  const InventoryProductsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final sortState = inventorySortStateSignal.value;

        return Container(
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 80, child: Text('ACTION', style: _headerStyle)),
              const Gap(16),
              const SizedBox(width: 56, child: Text('IMAGE', style: _headerStyle)),
              const Gap(16),
              SizedBox(width: 240, child: _sortable('PRODUCT NAME', ProductSortKey.name, sortState)),
              const Gap(16),
              SizedBox(width: 120, child: _sortable('SKU', ProductSortKey.sku, sortState)),
              const Gap(16),
              SizedBox(width: 130, child: _sortable('BARCODE', ProductSortKey.barcode, sortState)),
              const Gap(16),
              const SizedBox(width: 110, child: Text('STATUS', style: _headerStyle)),
              const Gap(16),
              SizedBox(width: 100, child: _sortable('STOCK', ProductSortKey.stock, sortState)),
              const Gap(16),
              SizedBox(width: 120, child: _sortable('LOW STOCK', ProductSortKey.lowStock, sortState)),
              const Gap(16),
              const SizedBox(width: 140, child: Text('STOCK MONITOR', style: _headerStyle)),
              const Gap(16),
              SizedBox(width: 160, child: _sortable('BASE PRICE (₹)', ProductSortKey.basePrice, sortState)),
              const Gap(16),
              SizedBox(width: 170, child: _sortable('SELLING PRICE (₹)', ProductSortKey.sellingPrice, sortState)),
              const Gap(16),
              SizedBox(width: 120, child: _sortable('TAX RATE', ProductSortKey.taxRate, sortState)),
              const Gap(16),
              const SizedBox(width: 140, child: Text('CATEGORY', style: _headerStyle)),
              const Gap(16),
              const SizedBox(width: 140, child: Text('COUNTER', style: _headerStyle)),
            ],
          ),
        );
      },
    );
  }

  static Widget _sortable(String label, ProductSortKey key, ProductSortState sortState) {
    final isActive = sortState.key == key;
    final isAsc = sortState.isAscending;

    return InkWell(
      onTap: () => inventorySortStateSignal.value = inventorySortStateSignal.value.toggle(key),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                letterSpacing: 0.5,
                color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              ),
            ),
            const Gap(4),
            Icon(
              isActive ? (isAsc ? FLucideIcons.arrowUp : FLucideIcons.arrowDown) : FLucideIcons.arrowUpDown,
              size: 13,
              color: isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: Color(0xFF64748B),
  );
}
