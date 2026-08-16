import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mix/mix.dart';

/// Clean pill-shaped search bar matching the customer web store search bar.
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
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Box(
      style: BoxStyler()
          .color(Colors.white)
          .borderRadiusAll(.circular(999))
          .borderAll(color: theme.colors.border)
          .shadowOnly(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 6,
          )
          .paddingLeft(20)
          .paddingRight(8)
          .paddingY(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FLucideIcons.search,
            color: Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: 'Search products by name or barcode...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(FLucideIcons.x, size: 18, color: Colors.grey.shade500),
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}
