import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';

/// Search input field for filtering inventory categories.
class InventoryCategoriesSearchField extends StatefulWidget {
  final double? width;
  const InventoryCategoriesSearchField({super.key, this.width});

  @override
  State<InventoryCategoriesSearchField> createState() =>
      _InventoryCategoriesSearchFieldState();
}

class _InventoryCategoriesSearchFieldState
    extends State<InventoryCategoriesSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
              controller: _controller,
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
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
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
    if (widget.width != null) return SizedBox(width: widget.width, child: box);
    return box;
  }
}
