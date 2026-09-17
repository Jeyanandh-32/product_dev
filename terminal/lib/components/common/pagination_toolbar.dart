import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/common/pagination_entries_menu.dart';
import 'package:terminal/components/common/pagination_nav_button.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Clean reusable docked pagination toolbar matching Finch POS aesthetic.
class PaginationToolbar extends StatefulWidget {
  /// Creates a reactive pagination toolbar bound to page and entry signals.
  const PaginationToolbar({
    super.key,
    required this.totalItems,
    required this.pageSignal,
    required this.entriesSignal,
    required this.totalPagesSignal,
  });

  /// Getter or signal reader returning total count of filtered items.
  final int Function() totalItems;

  /// Reactive signal controlling current page number (1-indexed).
  final Signal<int> pageSignal;

  /// Reactive signal controlling entries per page.
  final Signal<int> entriesSignal;

  /// Readonly signal providing computed total pages.
  final ReadonlySignal<int> totalPagesSignal;

  @override
  State<PaginationToolbar> createState() => _PaginationToolbarState();
}

class _PaginationToolbarState extends State<PaginationToolbar>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _entriesController;

  @override
  void initState() {
    super.initState();
    _entriesController = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _entriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final total = widget.totalItems();
        final page = widget.pageSignal.value;
        final entries = widget.entriesSignal.value;
        final totalPages = widget.totalPagesSignal.value;
        final isMobile = context.isMobile;
        final start = total == 0 ? 0 : ((page - 1) * entries) + 1;
        final end = (page * entries).clamp(0, total);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 16,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PaginationEntriesMenu(
                    currentEntries: entries,
                    controller: _entriesController,
                    onEntriesSelected: (size) {
                      widget.entriesSignal.value = size;
                      widget.pageSignal.value = 1;
                    },
                  ),
                  if (!isMobile) ...[
                    const Gap(10),
                    Text(
                      'Showing $start–$end of $total',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: TerminalColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PaginationNavButton(
                    icon: FLucideIcons.chevronLeft,
                    isEnabled: page > 1,
                    onTap: () => widget.pageSignal.value = page - 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$page / $totalPages',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: TerminalColors.textPrimary,
                      ),
                    ),
                  ),
                  PaginationNavButton(
                    icon: FLucideIcons.chevronRight,
                    isEnabled: page < totalPages,
                    onTap: () => widget.pageSignal.value = page + 1,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
