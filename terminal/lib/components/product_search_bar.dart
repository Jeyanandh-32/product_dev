import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    return Box(
      style: BoxStyler()
          .color(Colors.white)
          .borderRadiusAll(.circular(999))
          .borderAll(color: Colors.grey.shade200)
          .shadowOnly(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          )
          .paddingLeft(20)
          .paddingRight(6)
          .paddingY(4),
      child: RowBox(
        style: FlexBoxStyler().crossAxisAlignment(CrossAxisAlignment.center),
        children: [
          Expanded(
            child: ShadInput(
              controller: _controller,
              placeholder: StyledText(
                'Search something sweet on your mind...',
                style: TextStyler().fontSize(14).color(Colors.grey.shade400),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const ShadDecoration(
                border: ShadBorder.none,
                secondaryFocusedBorder: ShadBorder.none,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          Box(
            style: BoxStyler()
                .color(const Color(0xFFF3F4F6))
                .shape(.circle())
                .paddingAll(8),
            child: Icon(
              LucideIcons.search,
              color: Colors.grey.shade600,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
