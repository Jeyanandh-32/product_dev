import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/common/dropdown_filter_button.dart';
import 'package:terminal/components/common/dropdown_filter_menu.dart';
import 'package:terminal/components/common/dropdown_filter_variant.dart';
import 'package:terminal/theme.dart';

export 'package:terminal/components/common/dropdown_filter_variant.dart';

/// Generic dropdown popover filter button for table and view filters.
class DropdownFilter<T> extends StatefulWidget {
  /// Creates a generic dropdown filter button.
  const DropdownFilter({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onSelected,
    this.variant = DropdownFilterVariant.standard,
    this.height,
  });

  /// Display title or prefix label for the filter.
  final String label;

  /// Currently selected value (null indicates 'all' / no filter).
  final T? value;

  /// Available filter options.
  final List<({String label, T? value})> items;

  /// Callback when a value is selected.
  final ValueChanged<T?> onSelected;

  /// Visual presentation style (standard or pill).
  final DropdownFilterVariant variant;

  /// Custom height for the trigger button.
  final double? height;

  @override
  State<DropdownFilter<T>> createState() => _DropdownFilterState<T>();
}

class _DropdownFilterState<T> extends State<DropdownFilter<T>>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => widget.items.first,
    );

    final isFiltered = widget.value != null;
    final displayLabel =
        !isFiltered ? widget.label : '${widget.label}: ${selectedItem.label}';

    return FTheme(
      data: TerminalTheme.light(false),
      child: FPopover(
        control: .managed(controller: _controller),
        popoverAnchor: Alignment.topLeft,
        childAnchor: Alignment.bottomLeft,
        popoverBuilder: (context, controller) => DropdownFilterMenu<T>(
          items: widget.items,
          currentValue: widget.value,
          onSelected: widget.onSelected,
          controller: controller,
        ),
        child: DropdownFilterButton(
          displayLabel: displayLabel,
          isFiltered: isFiltered,
          variant: widget.variant,
          onTap: _controller.toggle,
          onClear: () => widget.onSelected(null),
          height: widget.height,
        ),
      ),
    );
  }
}
