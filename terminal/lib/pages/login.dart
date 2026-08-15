import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/terminal_login_form_card.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Terminal device authentication page.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<ShadFormState>();

  Future<void> _signIn() async {
    if (formKey.currentState!.saveAndValidate()) {
      final values = formKey.currentState!.value;
      final code = values['code'] as String;
      final password = values['password'] as String;
      try {
        await loginTerminal(code: code.trim(), password: password);
      } catch (e) {
        if (!mounted) return;
        final message = e is ApiException
            ? e.message
            : 'Login failed. Please check your credentials.';
        ShadToaster.of(context).show(
          ShadToast.destructive(
            closeIcon: const Icon(LucideIcons.x, color: Colors.white, size: 16),
            description: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.x, color: Colors.white, size: 20),
                const Gap(8),
                Text(message),
              ],
            ),
            alignment: Alignment.topCenter,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SignalBuilder(
      builder: (context) {
        final authState = authSignal.value;
        final isLoading = authState.isLoading;

        return Scaffold(
          body: isLoading
              ? const Loading()
              : Center(
                  child: Box(
                    style: BoxStyler()
                        .maxWidth(480)
                        .onMobile(BoxStyler().marginX(24)),
                    child: SingleChildScrollView(
                      child: ColumnBox(
                        children: [
                          StyledText(
                            'Branding',
                            style: TextStyler()
                                .fontSize(40)
                                .color(theme.colorScheme.primary)
                                .fontFamily(GoogleFonts.arizonia().fontFamily!),
                          ),
                          const Gap(16),
                          StyledText(
                            'Sign in to your account',
                            style: TextStyler().fontSize(30).fontWeight(.bold),
                          ),
                          const Gap(8),
                          StyledText(
                            'Enter your credentials to access the terminal\nand manage billing operations.',
                            style: TextStyler()
                                .textAlign(.center)
                                .fontSize(16)
                                .color(Colors.grey.shade600),
                          ),
                          const Gap(32),
                          TerminalLoginFormCard(
                            formKey: formKey,
                            isLoading: isLoading,
                            onSignIn: _signIn,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
