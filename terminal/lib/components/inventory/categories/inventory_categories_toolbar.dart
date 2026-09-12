import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/inventory_dropdown_filter.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Top control toolbar for Inventory Categories with search box, status filter, and add category action.
class InventoryCategoriesToolbar extends StatefulWidget {
  final VoidCallback onAddCategory;
  const InventoryCategoriesToolbar({super.key, required this.onAddCategory});

  @override
  State<InventoryCategoriesToolbar> createState() =>
      _InventoryCategoriesToolbarState();
}

class _InventoryCategoriesToolbarState
    extends State<InventoryCategoriesToolbar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return SignalBuilder(
      builder: (context) {
        final statusFilter = InventoryDropdownFilter<bool>(
          label: 'Status',
          value: categoryStatusFilterSignal.value,
          items: const [
            (label: 'All Status', value: null),
            (label: 'Active', value: true),
            (label: 'Inactive', value: false),
          ],
          onSelected: (val) {
            categoryStatusFilterSignal.value = val;
            categoryPageSignal.value = 1;
          },
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _buildSearchBox()),
                  const Gap(8),
                  _buildAddButton(),
                ],
              ),
              const Gap(10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [statusFilter]),
              ),
            ],
          );
        }

        return Row(
          children: [
            statusFilter,
            const Spacer(),
            _buildSearchBox(width: 230),
            const Gap(10),
            _buildAddButton(),
          ],
        );
      },
    );
  }

  Widget _buildSearchBox({double? width}) {
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
                categorySearchSignal.value = val;
                categoryPageSignal.value = 1;
                setState(() {});
              },
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
              decoration: const InputDecoration(
                hintText: 'Search categories...',
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
                categorySearchSignal.value = '';
                categoryPageSignal.value = 1;
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
    if (width != null) return SizedBox(width: width, child: box);
    return box;
  }

  Widget _buildAddButton() => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: PressableBox(
      onPress: widget.onAddCategory,
      style: BoxStyler()
          .color(TerminalColors.primary)
          .paddingX(14)
          .height(36)
          .borderRadiusAll(const Radius.circular(999))
          .alignment(Alignment.center)
          .onHovered(BoxStyler().color(TerminalColors.primaryHover)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FLucideIcons.plus, size: 14, color: Color(0xFFFFFFFF)),
          Gap(6),
          Text(
            'Add Category',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    ),
  );
}
