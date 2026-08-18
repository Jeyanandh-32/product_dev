import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/orders_entries_dropdown.dart';
import 'package:terminal/signals/orders_signal.dart';

/// Clean pagination control with entries selector and high-contrast page navigation.
class OrdersPagination extends SignalWidget {
  const OrdersPagination({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPage = orderCurrentPageSignal.value;
    final totalPages = orderTotalPagesSignal.value;
    final pages = _getPageNumbers(currentPage, totalPages);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const OrdersEntriesDropdown(),
          if (totalPages > 1)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavBtn(
                  icon: FLucideIcons.chevronLeft,
                  isEnabled: currentPage > 1,
                  onTap: () => orderCurrentPageSignal.value = currentPage - 1,
                ),
                const Gap(4),
                ...pages.map((p) {
                  if (p is String) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: StyledText(p,
                          style: TextStyler().fontSize(13.5).fontWeight(.w700).color(const Color(0xFF64748B))),
                    );
                  }
                  final pageNum = p as int;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildPagePill(
                      pageNum: pageNum,
                      isSelected: pageNum == currentPage,
                      onTap: () => orderCurrentPageSignal.value = pageNum,
                    ),
                  );
                }),
                const Gap(4),
                _buildNavBtn(
                  icon: FLucideIcons.chevronRight,
                  isEnabled: currentPage < totalPages,
                  onTap: () => orderCurrentPageSignal.value = currentPage + 1,
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Object> _getPageNumbers(int current, int total) {
    final pages = <Object>[];
    if (total <= 5) {
      for (var i = 1; i <= total; i++) {
        pages.add(i);
      }
    } else {
      pages.add(1);
      if (current > 3) pages.add('...');
      final start = (current - 1).clamp(2, total - 1);
      final end = (current + 1).clamp(2, total - 1);
      var finalStart = start;
      var finalEnd = end;
      if (current <= 3) finalEnd = 4;
      if (current >= total - 2) finalStart = total - 3;
      for (var i = finalStart; i <= finalEnd; i++) {
        pages.add(i);
      }
      if (current < total - 2) pages.add('...');
      pages.add(total);
    }
    return pages;
  }

  Widget _buildNavBtn({required IconData icon, required bool isEnabled, required VoidCallback onTap}) {
    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: PressableBox(
        onPress: isEnabled ? onTap : null,
        style: BoxStyler()
            .width(36)
            .height(36)
            .color(isEnabled ? const Color(0xFFFFFFFF) : const Color(0xFFF8FAFC))
            .borderRadiusAll(const Radius.circular(10))
            .borderAll(color: isEnabled ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9))
            .alignment(Alignment.center)
            .onHovered(
              isEnabled
                  ? BoxStyler().color(const Color(0xFFF8FAFC)).borderAll(color: const Color(0xFFCBD5E1))
                  : BoxStyler(),
            ),
        child: Icon(icon, size: 16, color: isEnabled ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1)),
      ),
    );
  }

  Widget _buildPagePill({required int pageNum, required bool isSelected, required VoidCallback onTap}) {
    final bgColor = isSelected ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final fgColor = isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);
    final borderColor = isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .width(36)
            .height(36)
            .color(bgColor)
            .borderRadiusAll(const Radius.circular(10))
            .borderAll(color: borderColor)
            .alignment(Alignment.center)
            .onHovered(
              isSelected
                  ? BoxStyler()
                  : BoxStyler().color(const Color(0xFFF8FAFC)).borderAll(color: const Color(0xFFCBD5E1)),
            ),
        child: StyledText('$pageNum',
            style: TextStyler().fontSize(13.5).fontWeight(isSelected ? .w900 : .w700).color(fgColor)),
      ),
    );
  }
}
