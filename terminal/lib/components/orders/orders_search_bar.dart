import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean circular pill search bar for orders matching the catalog search bar aesthetics.
class OrdersSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const OrdersSearchBar({super.key, this.onChanged});

  @override
  State<OrdersSearchBar> createState() => _OrdersSearchBarState();
}

class _OrdersSearchBarState extends State<OrdersSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: orderSearchQuerySignal.value);
  }

  void _handleChanged(String val) {
    orderSearchQuerySignal.value = val.trim().toLowerCase();
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
          const Icon(FLucideIcons.search, size: 16.5, color: Color(0xFF64748B)),
          const Gap(10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _handleChanged,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: TerminalColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Search by Bill # or Order Ref ID...',
                hintStyle: TextStyle(
                  fontSize: 14,
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
                _handleChanged('');
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(FLucideIcons.x, size: 16, color: Color(0xFF94A3B8)),
              ),
            ),
        ],
      ),
    );
  }
}
