import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:validators/validators.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      body: Center(
        child: Box(
          style: BoxStyler().maxWidth(480).onMobile(BoxStyler().paddingX(24)),
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
                              style: IconStyler().color(Colors.grey.shade600),
                            ),
                            StyledText(
                              'Terminal ID',
                              style: TextStyler()
                                  .fontSize(14)
                                  .fontWeight(.w600)
                                  .color(Colors.grey.shade600),
                            ),
                          ],
                        ),
                        Gap(16),
                        ShadInputFormField(
                          id: 'terminalId',
                          placeholder: StyledText('HINXXXXXXOE5'),
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
                              return 'Terminal ID is required.';
                            }
                            if (v.length < 12) {
                              return 'Terminal ID must be exactly 12 characters.';
                            }
                            return null;
                          },
                        ),

                        Gap(16),

                        RowBox(
                          style: FlexBoxStyler().spacing(8),
                          children: [
                            StyledIcon(
                              icon: LucideIcons.lock,
                              style: IconStyler().color(Colors.grey.shade600),
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
                        Gap(16),
                        ShadInputFormField(
                          id: 'password',
                          placeholder: StyledText('*********'),
                          obscureText: true,
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

                        Gap(28),

                        ShadButton(
                          width: .infinity,
                          height: 48,
                          child: StyledText('Sign In'),
                          onPressed: () {
                            if (formKey.currentState!.saveAndValidate()) {
                              final values = formKey.currentState!.value;
                              debugPrint('Valid form data: $values');
                            }
                          },
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
  }
}
