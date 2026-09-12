import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean payment method selector tabs positioned side-by-side with large readable tabs.
class CartPaymentModeSelector extends StatelessWidget {
  final PaymentMethod selectedMode;

  const CartPaymentModeSelector({super.key, required this.selectedMode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 310;
        final title = StyledText(
          'Payment Mode',
          style: TextStyler()
              .fontSize(14)
              .fontWeight(.w700)
              .color(TerminalColors.textPrimary),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: _buildTab(
                      PaymentMethod.cash,
                      'Cash',
                      FLucideIcons.banknote,
                    ),
                  ),
                  const Gap(4.5),
                  Expanded(
                    child: _buildTab(
                      PaymentMethod.upi,
                      'UPI',
                      FLucideIcons.qrCode,
                    ),
                  ),
                  const Gap(4.5),
                  Expanded(
                    child: _buildTab(
                      PaymentMethod.complimentary,
                      'Free',
                      FLucideIcons.gift,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: title),
            const Gap(6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTab(PaymentMethod.cash, 'Cash', FLucideIcons.banknote),
                const Gap(4.5),
                _buildTab(PaymentMethod.upi, 'UPI', FLucideIcons.qrCode),
                const Gap(4.5),
                _buildTab(
                  PaymentMethod.complimentary,
                  'Free',
                  FLucideIcons.gift,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTab(PaymentMethod mode, String label, IconData icon) => _ModeTab(
    mode: mode,
    label: label,
    icon: icon,
    isSelected: selectedMode == mode,
  );
}

class _ModeTab extends StatefulWidget {
  final PaymentMethod mode;
  final String label;
  final IconData icon;
  final bool isSelected;

  const _ModeTab({
    required this.mode,
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  @override
  State<_ModeTab> createState() => _ModeTabState();
}

class _ModeTabState extends State<_ModeTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isSelected || _isHovered;
    final bgColor = isDark ? TerminalColors.primary : const Color(0xFFF1F5F9);
    final borderColor = isDark
        ? TerminalColors.primary
        : const Color(0xFFCBD5E1);
    final fgColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        onPress: () => CartController.setPaymentMode(widget.mode),
        style: BoxStyler()
            .alignment(Alignment.center)
            .height(34)
            .paddingX(8.5)
            .borderRadiusAll(const Radius.circular(9))
            .color(bgColor)
            .borderAll(color: borderColor, width: isDark ? 1.5 : 1.0)
            .shadowOnly(
              color: const Color(0x08000000),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 13.5, color: fgColor),
            const Gap(4.5),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isDark ? FontWeight.w800 : FontWeight.w700,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
