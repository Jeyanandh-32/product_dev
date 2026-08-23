import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/account/account_status_badge.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Standard header for account information cards with clear high-contrast typography.
class AccountCardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool? isActive;
  final String? statusLabel;

  const AccountCardHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isActive,
    this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: TerminalColors.border),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: const Color(0xFF0F172A)),
        ),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isActive != null)
          AccountStatusBadge(
            isActive: isActive!,
            label: statusLabel,
          ),
      ],
    );
  }
}
