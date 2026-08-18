import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Terminal device authentication page with customer app brand styling using Forui.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static final String _arizoniaFontFamily =
      GoogleFonts.arizonia().fontFamily ?? 'Arizonia';
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
        if (!mounted) return;
        showFToast(
          context: context,
          alignment: .topCenter,
          duration: const Duration(seconds: 3),
          icon: const Icon(
            FLucideIcons.circleCheck,
            color: Color(0xFF16A34A),
            size: 20,
          ),
          title: const Text(
            'Login Successful',
            style: TextStyle(
              color: Color(0xFF16A34A),
              fontWeight: FontWeight.bold,
            ),
          ),
          description: const Text('Terminal session authenticated.'),
        );
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
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontWeight: FontWeight.bold,
            ),
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

    return FScaffold(
      childPad: false,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StyledText(
                  'Branding',
                  style: TextStyler()
                      .fontSize(56)
                      .fontFamily(_arizoniaFontFamily)
                      .color(theme.colors.primary),
                ),
                const Gap(8),
                StyledText(
                  'Cashier POS Portal',
                  style: TextStyler()
                      .fontSize(14)
                      .fontWeight(.w600)
                      .color(const Color(0xFF6B7280)),
                ),
                const Gap(32),
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
