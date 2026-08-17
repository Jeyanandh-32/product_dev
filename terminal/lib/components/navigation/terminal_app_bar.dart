import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/navigation/terminal_logout_button.dart';

/// Top POS App Header with pure white background, unbolded Arizonia branding, and bottom border.
class TerminalAppBar extends StatelessWidget {
  const TerminalAppBar({super.key});

  static final String _arizoniaFontFamily =
      GoogleFonts.arizonia().fontFamily ?? 'Arizonia';

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FHeader(
            title: StyledText(
              'Branding',
              style: TextStyler()
                  .fontSize(36)
                  .fontWeight(FontWeight.w400)
                  .fontFamily(_arizoniaFontFamily)
                  .color(theme.colors.primary),
            ),
            suffixes: const [
              TerminalLogoutButton(),
            ],
          ),
          Container(
            color: theme.colors.border,
            height: 1,
          ),
        ],
      ),
    );
  }
}
