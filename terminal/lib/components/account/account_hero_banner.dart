import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/account/account_hero_avatar.dart';
import 'package:terminal/components/account/account_status_badge.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Top hero banner displaying active terminal device, store, and merchant summary with high-contrast text.
class AccountHeroBanner extends StatelessWidget {
  final Terminal terminal;
  final Store? store;
  final Merchant? merchant;

  const AccountHeroBanner({
    super.key,
    required this.terminal,
    this.store,
    this.merchant,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(terminal.name);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TerminalColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AccountHeroAvatar(initials: initials),
          const Gap(18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        terminal.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(10),
                    AccountStatusBadge(isActive: terminal.isActive),
                  ],
                ),
                const Gap(6),
                Row(
                  children: [
                    const Icon(FLucideIcons.store, size: 14, color: Color(0xFF64748B)),
                    const Gap(5),
                    Flexible(
                      child: Text(
                        store?.name ?? 'Assigned Store',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (merchant != null) ...[
                      const Gap(8),
                      const Text('•', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                      const Gap(8),
                      const Icon(FLucideIcons.building2, size: 14, color: Color(0xFF64748B)),
                      const Gap(5),
                      Flexible(
                        child: Text(
                          merchant!.businessName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475569),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String text) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return text.length >= 2 ? text.substring(0, 2).toUpperCase() : text.toUpperCase();
  }
}
