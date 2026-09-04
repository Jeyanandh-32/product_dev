import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/inventory/modals/compact_switch.dart';

/// Search input bar with consistent pill styling and compact Select All toggle.
class ReturnableProductsSearchBar extends StatelessWidget {
  const ReturnableProductsSearchBar({
    required this.controller,
    required this.areAllReturnable,
    required this.onSearchChanged,
    required this.onToggleAll,
    super.key,
  });

  final TextEditingController controller;
  final bool areAllReturnable;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<bool> onToggleAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 38,
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
                const Icon(
                  FLucideIcons.search,
                  size: 14.5,
                  color: Color(0xFF64748B),
                ),
                const Gap(8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onSearchChanged,
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
                if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      controller.clear();
                      onSearchChanged('');
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        FLucideIcons.x,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Gap(10),
        Container(
          height: 38,
          padding: const EdgeInsets.only(left: 12, right: 8),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF475569),
                ),
              ),
              const Gap(8),
              CompactSwitch(value: areAllReturnable, onChanged: onToggleAll),
            ],
          ),
        ),
      ],
    );
  }
}
