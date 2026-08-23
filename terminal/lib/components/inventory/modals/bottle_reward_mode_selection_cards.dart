import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';

/// Touch-friendly mode cards with hover effects for BottleRewardModeDialog.
class BottleRewardModeSelectionCards extends StatelessWidget {
  final BottleRewardMode selectedMode;
  final ValueChanged<BottleRewardMode> onSelectMode;

  const BottleRewardModeSelectionCards({
    super.key,
    required this.selectedMode,
    required this.onSelectMode,
  });

  Widget _buildCard({
    required BottleRewardMode mode,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = selectedMode == mode;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: PressableBox(
          onPress: () => onSelectMode(mode),
          style: BoxStyler()
              .height(96)
              .paddingAll(12)
              .borderRadiusAll(const Radius.circular(16))
              .color(
                isSelected ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
              )
              .borderAll(
                color: isSelected
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFE2E8F0),
                width: isSelected ? 2 : 1,
              )
              .alignment(Alignment.center)
              .onHovered(
                BoxStyler()
                    .color(const Color(0xFFF0FDF4))
                    .borderAll(color: const Color(0xFF22C55E)),
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF64748B),
              ),
              const Gap(6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFF166534)
                      : const Color(0xFF0F172A),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? const Color(0xFF15803D)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCard(
          mode: BottleRewardMode.digital,
          icon: FLucideIcons.smartphone,
          title: 'Digital Wallet',
          subtitle: 'Credit to Phone',
        ),
        const Gap(12),
        _buildCard(
          mode: BottleRewardMode.physical,
          icon: FLucideIcons.ticket,
          title: 'Paper Voucher',
          subtitle: 'Print QR Voucher',
        ),
      ],
    );
  }
}
