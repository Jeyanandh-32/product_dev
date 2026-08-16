import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/terminal_login_form_card.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Terminal device authentication page with customer app brand styling.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static final String _arizoniaFontFamily = GoogleFonts.arizonia().fontFamily!;
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.validate() ?? false) {
      final code = codeController.text.trim();
      final password = passwordController.text;

      setState(() => _isSubmitting = true);
      try {
        await loginTerminal(code: code, password: password);
      } catch (e) {
        if (!mounted) return;
        final message = e is ApiException
            ? e.message
            : 'Login failed. Please check your credentials.';
        showFToast(
          context: context,
          alignment: .topCenter,
          duration: const Duration(seconds: 4),
          icon: const Icon(
            FLucideIcons.circleAlert,
            color: Color(0xFFDC2626),
            size: 20,
          ),
          title: const Text(
            'Authentication Error',
            style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
          ),
          description: Text(message),
        );
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Box(
          style: BoxStyler()
              .maxWidth(480)
              .onMobile(BoxStyler().marginX(20)),
          child: SingleChildScrollView(
            child: ColumnBox(
              children: [
                StyledText(
                  'Branding',
                  style: TextStyler()
                      .fontSize(44)
                      .color(theme.colors.primary)
                  .fontFamily(_arizoniaFontFamily),
                ),
                const Gap(12),
                StyledText(
                  'Sign in to your terminal',
                  style: TextStyler()
                      .fontSize(28)
                      .fontWeight(.w800)
                      .color(Colors.black),
                ),
                const Gap(8),
                StyledText(
                  'Enter your device credentials to access the terminal\nand manage instant checkout operations.',
                  style: TextStyler()
                      .textAlign(.center)
                      .fontSize(14)
                      .color(Colors.grey.shade600),
                ),
                const Gap(28),
                TerminalLoginFormCard(
                  formKey: formKey,
                  codeController: codeController,
                  passwordController: passwordController,
                  isLoading: _isSubmitting,
                  onSignIn: _signIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
