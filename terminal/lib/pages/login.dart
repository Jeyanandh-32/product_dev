import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/providers/auth_provider.dart';
import 'package:validators/validators.dart';

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
                                ),
                            child: ShadForm(
                              key: formKey,
                              child: ColumnBox(
                                children: [
                                  RowBox(
                                    style: FlexBoxStyler().spacing(8),
                                    children: [
                                      StyledIcon(
                                        icon: LucideIcons.monitor,
                                        style: IconStyler().color(
                                          Colors.grey.shade600,
                                        ),
                                      ),
                                      StyledText(
                                        'Terminal Code',
                                        style: TextStyler()
                                            .fontSize(14)
                                            .fontWeight(.w600)
                                            .color(Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  ShadInputFormField(
                                    id: 'code',
                                    placeholder: const StyledText(
                                      'HINXXXXXXOE5',
                                    ),
                                    textInputAction: .next,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(12),
                                      TextInputFormatter.withFunction((
                                        oldValue,
                                        newValue,
                                      ) {
                                        return TextEditingValue(
                                          text: newValue.text.toUpperCase(),
                                          selection: newValue.selection,
                                        );
                                      }),
                                    ],
                                    validator: (v) {
                                      if (v.trim().isEmpty) {
                                        return 'Terminal Code is required.';
                                      }
                                      if (v.length < 12) {
                                        return 'Terminal Code must be exactly 12 characters.';
                                      }
                                      return null;
                                    },
                                  ),

                                  const Gap(16),

                                  RowBox(
                                    style: FlexBoxStyler().spacing(8),
                                    children: [
                                      StyledIcon(
                                        icon: LucideIcons.lock,
                                        style: IconStyler().color(
                                          Colors.grey.shade600,
                                        ),
                                      ),
                                      StyledText(
                                        'Password',
                                        style: TextStyler()
                                            .fontSize(14)
                                            .fontWeight(.w600)
                                            .color(Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  ShadInputFormField(
                                    id: 'password',
                                    placeholder: const StyledText('*********'),
                                    textInputAction: .done,
                                    obscureText: true,
                                    onSubmitted: (value) => _signIn(),
                                    validator: (v) {
                                      if (v.isEmpty) {
                                        return 'Password is required.';
                                      }
                                      if (!RegExp(
                                        ValidationPatterns.password,
                                      ).hasMatch(v)) {
                                        return 'Must be 6+ characters with a number, lowercase, and uppercase.';
                                      }
                                      return null;
                                    },
                                  ),

                                  const Gap(28),

                                  ShadButton(
                                    width: .infinity,
                                    height: 48,
                                    shadows: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.3),
                                        offset: const Offset(0, 3),
                                        blurRadius: 2,
                                        spreadRadius: -2,
                                      ),
                                      BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.3),
                                        offset: const Offset(0, 4),
                                        blurRadius: 3,
                                        spreadRadius: -2,
                                      ),
                                    ],
                                    onPressed: isLoading ? null : _signIn,
                                    child: const StyledText('Sign In'),
                                  ),
                                ],
                              ),
                            ),
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
