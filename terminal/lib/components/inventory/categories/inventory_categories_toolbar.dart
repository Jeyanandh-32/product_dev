import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/categories/inventory_categories_search_field.dart';
import 'package:terminal/components/inventory/inventory_dropdown_filter.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

export 'package:terminal/components/inventory/categories/inventory_categories_search_field.dart';

/// Top control toolbar for Inventory Categories with search box, status filter, and add category action.
class InventoryCategoriesToolbar extends StatelessWidget {
  final VoidCallback onAddCategory;
  const InventoryCategoriesToolbar({super.key, required this.onAddCategory});

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
                  const Expanded(child: InventoryCategoriesSearchField()),
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
            const InventoryCategoriesSearchField(width: 230),
            const Gap(10),
            _buildAddButton(),
          ],
        );
      },
    );
  }

  Widget _buildAddButton() => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: PressableBox(
      onPress: onAddCategory,
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
