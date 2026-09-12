import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Terminal device authentication page with customer app brand styling using Forui.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    if (_isSubmitting) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.validate() ?? false) {
      final code = codeController.text.trim();
      final password = passwordController.text;

      setState(() => _isSubmitting = true);
      try {
        await loginTerminal(code: code, password: password);
        if (!mounted) return;
        TerminalToast.showSuccess(
          context: context,
          title: 'Login Successful',
          description: 'Terminal session authenticated.',
        );
      } catch (e) {
        if (!mounted) return;
        final message = e is ApiException
            ? e.message
            : 'Login failed. Please check your credentials.';
        TerminalToast.showError(
          context: context,
          title: 'Authentication Error',
          description: message,
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
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
                Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/finch_app_icon_square.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Finch',
                  style: GoogleFonts.dancingScript(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: theme.colors.primary,
                  ),
                ),
                const Gap(6),
                StyledText(
                  'Cashier POS Portal',
                  style: TextStyler()
                      .fontSize(14)
                      .fontWeight(FontWeight.w600)
                      .color(const Color(0xFF64748B)),
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
