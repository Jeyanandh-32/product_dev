import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/account/account_hero_avatar.dart';
import 'package:terminal/components/account/account_hero_details.dart';
import 'package:terminal/components/account/account_status_badge.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Top hero banner displaying active terminal device, store, and merchant summary.
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
    final isMobile = context.isMobile;

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
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AccountHeroAvatar(initials: initials),
          Gap(isMobile ? 14 : 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        terminal.name,
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(8),
                    AccountStatusBadge(isActive: terminal.isActive),
                  ],
                ),
                Gap(isMobile ? 8 : 6),
                AccountHeroDetails(store: store, merchant: merchant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String text) {
    final parts = text.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return text.length >= 2
        ? text.substring(0, 2).toUpperCase()
        : text.toUpperCase();
  }
}
