import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      body: Center(
        child: Box(
          style: BoxStyler().maxWidth(480).onMobile(BoxStyler().paddingX(24)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StyledText(
                  'Branding',
                  style: TextStyler()
                      .fontSize(40)
                      .color(theme.colorScheme.primary)
                      .fontFamily(GoogleFonts.arizonia().fontFamily!),
                ),
                Gap(16),
                StyledText(
                  'Sign in to your account',
                  style: TextStyler().fontSize(30).fontWeight(.bold),
                ),
                Gap(8),
                StyledText(
                  'Enter to your credentials to access\nand tracking sales today.',
                  style: TextStyler()
                      .textAlign(.center)
                      .fontSize(16)
                      .color(Colors.grey.shade600),
                ),
                Gap(32),
                Box(
                  style: BoxStyler()
                      .color(Colors.white)
                      .width(double.infinity)
                      .borderRadius(.circular(8))
                      .paddingAll(24)
                      .shadowOnly(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      )
                      .height(500),
                  child: Column(
                    children: [
                      StyledText(
                        'Terminal ID',
                        style: TextStyler()
                            .fontSize(14)
                            .fontWeight(.w600)
                            .color(Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
