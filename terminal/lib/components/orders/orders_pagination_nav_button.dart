import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Tactile previous/next arrow button for pagination.
class OrdersPaginationNavButton extends StatelessWidget {
  const OrdersPaginationNavButton({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: PressableBox(
        onPress: isEnabled ? onTap : null,
        style: BoxStyler()
            .width(30)
            .height(30)
            .color(isEnabled ? const Color(0xFFF8FAFC) : const Color(0xFFFFFFFF))
            .borderRadiusAll(const Radius.circular(8))
            .borderAll(color: isEnabled ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9))
            .alignment(Alignment.center)
            .onHovered(isEnabled ? BoxStyler().color(const Color(0xFFF1F5F9)) : BoxStyler()),
        child: Icon(icon, size: 14, color: isEnabled ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1)),
      ),
    );
  }
}

/// Tactile page number button pill for pagination.
class OrdersPaginationPagePill extends StatelessWidget {
  const OrdersPaginationPagePill({
    required this.pageNum,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final int pageNum;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .width(30)
            .height(30)
            .color(isSelected ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF))
            .borderRadiusAll(const Radius.circular(8))
            .borderAll(color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0))
            .alignment(Alignment.center)
            .onHovered(isSelected ? BoxStyler() : BoxStyler().color(const Color(0xFFF8FAFC))),
        child: Text(
          '$pageNum',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}
