import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Submit action button for the terminal login form using Mix and Forui (rounded-2xl).
class TerminalLoginSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSignIn;

  const TerminalLoginSubmitButton({
    super.key,
    required this.isLoading,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PressableBox(
        onPress: isLoading ? null : onSignIn,
        style: BoxStyler()
            .alignment(Alignment.center)
            .height(48)
            .borderRadiusAll(const Radius.circular(16))
            .color(TerminalColors.primary)
            .onHovered(
              BoxStyler()
                  .color(TerminalColors.primaryHover)
                  .shadowOnly(
                    color: const Color(0x380B132B),
                    offset: const Offset(0, 4),
                    blurRadius: 14,
                  ),
            ),
        child: Center(
          child: isLoading
              ? FCircularProgress(
                  style: FCircularProgressStyle(
                    iconStyle: const IconThemeData(
                      size: 20,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Gap(8),
                    Icon(
                      FLucideIcons.arrowRight,
                      size: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
