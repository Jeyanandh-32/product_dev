import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/products_signal.dart';

/// Clean circular pill search bar using Mix [Box].
class ProductSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const ProductSearchBar({super.key, this.onChanged});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: searchQuerySignal.value);
  }

  void _handleChanged(String val) {
    searchQuerySignal.value = val.trim().toLowerCase();
    widget.onChanged?.call(val);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .height(44)
          .color(const Color(0xFFFFFFFF))
          .borderRadiusAll(const Radius.circular(999))
          .borderAll(color: const Color(0xFFE2E8F0))
          .shadowOnly(
            color: const Color(0x08000000),
            offset: const Offset(0, 1),
            blurRadius: 3,
          )
          .paddingLeft(16)
          .paddingRight(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            FLucideIcons.search,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          const Gap(10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _handleChanged,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000000),
              ),
              decoration: const InputDecoration(
                hintText: 'Search products by name, SKU or barcode...',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
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
                _handleChanged('');
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(
                  FLucideIcons.x,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
