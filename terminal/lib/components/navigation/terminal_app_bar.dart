import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terminal/components/navigation/terminal_bottle_returns_button.dart';
import 'package:terminal/components/navigation/terminal_logout_button.dart';
import 'package:terminal/components/navigation/terminal_navigation_dropdown.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Top POS App Header with Finch branding, navigation menu, and logout button.
class TerminalAppBar extends StatelessWidget {
  const TerminalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FHeader(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: context.isMobile ? 28 : 32,
                  height: context.isMobile ? 28 : 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/finch_app_icon_square.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(10),
                Text(
                  'Finch',
                  style: GoogleFonts.dancingScript(
                    fontSize: context.isMobile ? 26 : 30,
                    fontWeight: FontWeight.w700,
                    color: theme.colors.primary,
                  ),
                ),
              ],
            ),
            suffixes: const [
              TerminalBottleReturnsButton(),
              TerminalNavigationDropdown(),
              Gap(8),
              TerminalLogoutButton(),
            ],
          ),
          Container(color: theme.colors.border, height: 1),
        ],
      ),
    );
  }
}
