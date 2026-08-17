import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Single category filter pill button with avatar badge and hover animation.
class CategoryFilterPill extends StatefulWidget {
  final String label;
  final String avatarText;
  final bool isSelected;
  final VoidCallback onTap;
  final Key? pillKey;

  const CategoryFilterPill({
    super.key,
    required this.label,
    required this.avatarText,
    required this.isSelected,
    required this.onTap,
    this.pillKey,
  });

  @override
  State<CategoryFilterPill> createState() => _CategoryFilterPillState();
}

class _CategoryFilterPillState extends State<CategoryFilterPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isSelected || _isHovered;
    final bgColor = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF000000) : const Color(0xFFE5E7EB);
    final fgColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1F2937);
    final avatarBg = isDark ? const Color(0x33FFFFFF) : const Color(0xFFF3F4F6);
    final avatarFg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        key: widget.pillKey,
        onPress: widget.onTap,
        style: BoxStyler()
            .color(bgColor)
            .paddingY(5)
            .paddingLeft(6)
            .paddingRight(16)
            .borderRadiusAll(const Radius.circular(999))
            .borderAll(color: borderColor)
            .shadowOnly(
              color: const Color(0x08000000),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Box(
              style: BoxStyler()
                  .width(28)
                  .height(28)
                  .borderRadiusAll(const Radius.circular(999))
                  .color(avatarBg),
              child: Center(
                child: Text(
                  widget.avatarText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: avatarFg,
                  ),
                ),
              ),
            ),
            const Gap(8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
