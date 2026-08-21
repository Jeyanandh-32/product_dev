import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Premium segmented source tab bar for switching between 'This Terminal' and 'Online Orders'.
class OrdersSourceTabs extends SignalWidget {
  const OrdersSourceTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final activeTab = orderSourceTabSignal.value;
    final terminalCount = terminalTabCountSignal.value;
    final onlineCount = onlineTabCountSignal.value;

    return Box(
      style: BoxStyler()
          .height(48)
          .color(TerminalColors.secondaryBackground)
          .paddingAll(4)
          .borderRadiusAll(const Radius.circular(14))
          .borderAll(color: TerminalColors.border),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'This Terminal',
              icon: FLucideIcons.monitor,
              count: terminalCount,
              isSelected: activeTab == OrderSourceTab.thisTerminal,
              onTap: () {
                if (activeTab == OrderSourceTab.thisTerminal) return;
                orderSourceTabSignal.value = OrderSourceTab.thisTerminal;
                orderPaymentStatusFilterSignal.value = null;
                orderCurrentPageSignal.value = 1;
                refreshOrdersSignal();
              },
            ),
          ),
          const Gap(4),
          Expanded(
            child: _TabButton(
              title: 'Online Orders',
              icon: FLucideIcons.globe,
              count: onlineCount,
              isSelected: activeTab == OrderSourceTab.online,
              onTap: () {
                if (activeTab == OrderSourceTab.online) return;
                orderSourceTabSignal.value = OrderSourceTab.online;
                orderPaymentMethodFilterSignal.value = null;
                orderCurrentPageSignal.value = 1;
                refreshOrdersSignal();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? TerminalColors.surface : TerminalColors.transparent;
    final fgColor = isSelected ? TerminalColors.textBlack : TerminalColors.textLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressableBox(
        onPress: onTap,
        style: BoxStyler()
            .height(40)
            .color(bgColor)
            .paddingX(14)
            .borderRadiusAll(const Radius.circular(10))
            .borderAll(color: isSelected ? TerminalColors.border : TerminalColors.transparent)
            .shadowOnly(
              color: isSelected ? TerminalColors.shadow : TerminalColors.transparent,
              offset: const Offset(0, 1),
              blurRadius: 3,
            )
            .alignment(Alignment.center)
            .onHovered(
              isSelected
                  ? BoxStyler()
                  : BoxStyler().color(TerminalColors.surface).borderAll(color: TerminalColors.border),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.5, color: fgColor),
            const Gap(8),
            Flexible(
              child: StyledText(
                title,
                style: TextStyler().fontSize(14.5).fontWeight(isSelected ? .w800 : .w700).color(fgColor),
              ),
            ),
            if (isSelected) ...[
              const Gap(8),
              Box(
                style: BoxStyler()
                    .color(TerminalColors.primary)
                    .height(20)
                    .paddingX(7)
                    .alignment(Alignment.center)
                    .borderRadiusAll(const Radius.circular(6)),
                child: StyledText(
                  count.toString(),
                  style: TextStyler().fontSize(11.5).fontWeight(.w800).color(TerminalColors.textWhite),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
