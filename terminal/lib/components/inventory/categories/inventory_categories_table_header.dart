import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';

/// Pinned sticky header for POS categories table matching DaisyUI thead.
class InventoryCategoriesTableHeader extends StatelessWidget {
  const InventoryCategoriesTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final sortState = categorySortStateSignal.value;

        return Container(
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 50, child: Text('ACTION', style: _headerStyle)),
              const Gap(16),
              const SizedBox(width: 56, child: Text('IMAGE', style: _headerStyle)),
              const Gap(16),
              Expanded(
                flex: 3,
                child: _sortable('NAME', CategorySortKey.name, sortState),
              ),
              const Gap(16),
              const Expanded(
                flex: 2,
                child: Text('STATUS', style: _headerStyle),
              ),
              const Gap(16),
              Expanded(
                flex: 3,
                child: _sortable('ASSOCIATED PRODUCTS', CategorySortKey.productCount, sortState),
              ),
              const Gap(16),
              Expanded(
                flex: 3,
                child: _sortable('DESCRIPTION', CategorySortKey.description, sortState),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _sortable(String label, CategorySortKey key, CategorySortState sortState) {
    final isActive = sortState.key == key;
    final isAsc = sortState.isAscending;

    return InkWell(
      onTap: () => categorySortStateSignal.value = categorySortStateSignal.value.toggle(key),
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
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: Color(0xFF64748B),
  );
}
