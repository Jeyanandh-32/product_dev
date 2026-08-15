import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:validators/validators.dart';

/// Clean card container with terminal login form fields and submit action.
class TerminalLoginFormCard extends StatelessWidget {
  final GlobalKey<ShadFormState> formKey;
  final bool isLoading;
  final VoidCallback onSignIn;

  const TerminalLoginFormCard({
    super.key,
    required this.formKey,
    required this.isLoading,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Box(
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
              placeholder: const StyledText('HINXXXXXXOE5'),
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
            const Gap(16),
            ShadInputFormField(
              id: 'password',
              placeholder: const StyledText('*********'),
              textInputAction: .done,
              obscureText: true,
              onSubmitted: (value) => onSignIn(),
              validator: (v) {
                if (v.isEmpty) {
                  return 'Password is required.';
                }
                if (!RegExp(ValidationPatterns.password).hasMatch(v)) {
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
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  offset: const Offset(0, 3),
                  blurRadius: 2,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 3,
                  spreadRadius: -2,
                ),
              ],
              onPressed: isLoading ? null : onSignIn,
              child: const StyledText('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
