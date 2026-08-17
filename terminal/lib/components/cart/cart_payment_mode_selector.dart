import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Clean payment method selector tabs positioned side-by-side with the label text.
class CartPaymentModeSelector extends StatelessWidget {
  final PaymentMethod selectedMode;

  const CartPaymentModeSelector({super.key, required this.selectedMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StyledText(
          'Payment Mode',
          style: TextStyler()
              .fontSize(13.5)
              .fontWeight(.w600)
              .color(const Color(0xFF334155)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ModeTab(
              mode: PaymentMethod.cash,
              label: 'Cash',
              icon: FLucideIcons.banknote,
              isSelected: selectedMode == PaymentMethod.cash,
            ),
            const Gap(6),
            _ModeTab(
              mode: PaymentMethod.upi,
              label: 'UPI',
              icon: FLucideIcons.qrCode,
              isSelected: selectedMode == PaymentMethod.upi,
            ),
            const Gap(6),
            _ModeTab(
              mode: PaymentMethod.complimentary,
              label: 'Free',
              icon: FLucideIcons.gift,
              isSelected: selectedMode == PaymentMethod.complimentary,
            ),
          ],
        ),
      ],
    );
  }
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
    final bgColor = isDark ? const Color(0xFF000000) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF000000) : const Color(0xFFE2E8F0);
    final fgColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF374151);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: PressableBox(
        onPress: () => CartController.setPaymentMode(widget.mode),
        style: BoxStyler()
            .alignment(Alignment.center)
            .height(30)
            .paddingX(10)
            .borderRadiusAll(const Radius.circular(10))
            .color(bgColor)
            .borderAll(color: borderColor)
            .shadowOnly(
              color: const Color(0x08000000),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 13, color: fgColor),
            const Gap(5),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isDark ? FontWeight.w800 : FontWeight.w600,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
