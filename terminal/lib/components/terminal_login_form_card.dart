import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:validators/validators.dart';

/// Clean card container with terminal login form fields and submit action using Forui.
class TerminalLoginFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSignIn;

  const TerminalLoginFormCard({
    super.key,
    required this.formKey,
    required this.codeController,
    required this.passwordController,
    required this.isLoading,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Box(
      style: BoxStyler()
          .color(Colors.white)
          .width(double.infinity)
          .borderRadius(.circular(16))
          .paddingAll(28)
          .borderAll(color: theme.colors.border)
          .shadowOnly(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
      child: Form(
        key: formKey,
        child: ColumnBox(
          children: [
            RowBox(
              style: FlexBoxStyler().spacing(8).crossAxisAlignment(CrossAxisAlignment.center),
              children: [
                Icon(
                  FLucideIcons.monitor,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                StyledText(
                  'Terminal Code',
                  style: TextStyler()
                      .fontSize(14)
                      .fontWeight(.w700)
                      .color(Colors.grey.shade700),
                ),
              ],
            ),
            const Gap(8),
            FTextFormField(
              control: .managed(controller: codeController),
              hint: 'HINXXXXXXOE5',
              textInputAction: .next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return TextEditingValue(
                    text: newValue.text.toUpperCase(),
                    selection: newValue.selection,
                  );
                }),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Terminal Code is required.';
                }
                if (v.trim().length < 12) {
                  return 'Terminal Code must be exactly 12 characters.';
                }
                return null;
              },
            ),

            const Gap(20),

            RowBox(
              style: FlexBoxStyler().spacing(8).crossAxisAlignment(CrossAxisAlignment.center),
              children: [
                Icon(
                  FLucideIcons.lock,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                StyledText(
                  'Password',
                  style: TextStyler()
                      .fontSize(14)
                      .fontWeight(.w700)
                      .color(Colors.grey.shade700),
                ),
              ],
            ),
            const Gap(8),
            FTextFormField.password(
              control: .managed(controller: passwordController),
              hint: '*********',
              textInputAction: .done,
              onSubmit: (_) => onSignIn(),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Password is required.';
                }
                if (!RegExp(ValidationPatterns.password).hasMatch(v)) {
                  return 'Must be 6+ characters with a number, lowercase, and uppercase.';
                }
                return null;
              },
              label: null,
            ),
            const Gap(28),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onSignIn,
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isLoading ? const Color(0xFF1F2937) : Colors.black,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade800),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Signing In...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                FLucideIcons.arrowRight,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
