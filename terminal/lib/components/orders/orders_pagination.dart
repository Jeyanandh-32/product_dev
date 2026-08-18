import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/orders/orders_entries_dropdown.dart';
import 'package:terminal/components/orders/orders_pagination_nav_button.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Premium floating pagination toolbar with entries selector and tactile page controls.
class OrdersPagination extends SignalWidget {
  const OrdersPagination({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final currentPage = orderCurrentPageSignal.value;
    final totalPages = orderTotalPagesSignal.value;
    final pages = _getPageNumbers(currentPage, totalPages);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const OrdersEntriesDropdown(),
          if (totalPages > 1)
            isMobile
                ? _buildMobileNav(currentPage, totalPages)
                : _buildDesktopNav(currentPage, totalPages, pages),
        ],
      ),
    );
  }

  Widget _buildMobileNav(int currentPage, int totalPages) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OrdersPaginationNavButton(
          icon: FLucideIcons.chevronLeft,
          isEnabled: currentPage > 1,
          onTap: () => _goToPage(currentPage - 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$currentPage / $totalPages',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
        ),
        OrdersPaginationNavButton(
          icon: FLucideIcons.chevronRight,
          isEnabled: currentPage < totalPages,
          onTap: () => _goToPage(currentPage + 1),
        ),
      ],
    );
  }

  Widget _buildDesktopNav(int currentPage, int totalPages, List<Object> pages) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OrdersPaginationNavButton(
          icon: FLucideIcons.chevronLeft,
          isEnabled: currentPage > 1,
          onTap: () => _goToPage(currentPage - 1),
        ),
        const Gap(4),
        ...pages.map((p) {
          if (p is String) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
            );
          }
          final pageNum = p as int;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: OrdersPaginationPagePill(
              pageNum: pageNum,
              isSelected: pageNum == currentPage,
              onTap: () => _goToPage(pageNum),
            ),
          );
        }),
        const Gap(4),
        OrdersPaginationNavButton(
          icon: FLucideIcons.chevronRight,
          isEnabled: currentPage < totalPages,
          onTap: () => _goToPage(currentPage + 1),
        ),
      ],
    );
  }

  void _goToPage(int page) {
    orderCurrentPageSignal.value = page;
    refreshOrdersSignal();
  }

  List<Object> _getPageNumbers(int current, int total) {
    if (total <= 5) return List.generate(total, (i) => i + 1);
    final pages = <Object>[1];
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
    return pages;
  }
}
