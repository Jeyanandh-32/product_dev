import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Pinned sticky left header containing Action, Image, and sortable Product Name columns.
class InventoryProductsPinnedHeader extends StatelessWidget {
  const InventoryProductsPinnedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final sortState = inventorySortStateSignal.value;

        return Container(
          height: 48,
          decoration: const BoxDecoration(
            color: TerminalColors.pageBackground,
            border: Border(
              bottom: BorderSide(color: TerminalColors.border, width: 1),
              right: BorderSide(color: TerminalColors.border, width: 1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: TerminalColors.shadow,
                offset: Offset(2, 0),
                blurRadius: 3,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 80, child: Text('ACTION', style: _headerStyle)),
              const Gap(16),
              const SizedBox(width: 56, child: Text('IMAGE', style: _headerStyle)),
              const Gap(16),
              Expanded(
                child: _sortable('PRODUCT NAME', ProductSortKey.name, sortState),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _sortable(String label, ProductSortKey key, ProductSortState sortState) {
    final isActive = sortState.key == key;
    final isAsc = sortState.isAscending;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
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
                  color: isActive ? TerminalColors.textPrimary : TerminalColors.textSecondary,
                ),
              ),
              const Gap(4),
              Icon(
                isActive ? (isAsc ? FLucideIcons.arrowUp : FLucideIcons.arrowDown) : FLucideIcons.arrowUpDown,
                size: 13,
                color: isActive ? TerminalColors.textPrimary : TerminalColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: TerminalColors.textSecondary,
  );
}
