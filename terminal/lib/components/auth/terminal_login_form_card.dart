import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/components/auth/login_input_field.dart';
import 'package:terminal/components/auth/terminal_login_submit_button.dart';

/// Clean card container with terminal login form fields (42px) and submit action using Mix and Forui.
class TerminalLoginFormCard extends StatefulWidget {
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
  State<TerminalLoginFormCard> createState() => _TerminalLoginFormCardState();
}

class _TerminalLoginFormCardState extends State<TerminalLoginFormCard> {
  final FocusNode _codeFocusNode = FocusNode(debugLabel: 'codeFocusNode');
  final FocusNode _passwordFocusNode = FocusNode(
    debugLabel: 'passwordFocusNode',
  );

  @override
  void dispose() {
    _codeFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleCodeSubmit() {
    if (widget.passwordController.text.trim().isNotEmpty) {
      if (!widget.isLoading) widget.onSignIn();
    } else {
      _passwordFocusNode.requestFocus();
    }
  }

  void _handlePasswordSubmit() {
    if (!widget.isLoading) widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Box(
      style: BoxStyler()
          .color(const Color(0xFFFFFFFF))
          .width(double.infinity)
          .borderRadiusAll(const Radius.circular(24))
          .paddingAll(28)
          .borderAll(color: theme.colors.border)
          .shadowOnly(
            color: const Color(0x0A000000),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _fieldLabel(icon: FLucideIcons.monitor, label: 'Terminal Code'),
            const Gap(8),
            LoginInputField(
              key: const ValueKey('terminal_code_field'),
              controller: widget.codeController,
              focusNode: _codeFocusNode,
              hint: 'HINXXXXXXOE5',
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return TextEditingValue(
                    text: newValue.text.toUpperCase(),
                    selection: newValue.selection,
                  );
                }),
              ],
              onEditingComplete: _handleCodeSubmit,
              onSubmitted: (_) => _handleCodeSubmit(),
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
            _fieldLabel(icon: FLucideIcons.lock, label: 'Password'),
            const Gap(8),
            LoginInputField(
              key: const ValueKey('terminal_password_field'),
              controller: widget.passwordController,
              focusNode: _passwordFocusNode,
              hint: '••••••••',
              isPassword: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: _handlePasswordSubmit,
              onSubmitted: (_) => _handlePasswordSubmit(),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Password is required.' : null,
            ),
            const Gap(28),
            TerminalLoginSubmitButton(
              isLoading: widget.isLoading,
              onSignIn: widget.onSignIn,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel({required IconData icon, required String label}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF374151)),
        const Gap(8),
        StyledText(
          label,
          style: TextStyler()
              .fontSize(14)
              .fontWeight(.w700)
              .color(const Color(0xFF374151)),
        ),
      ],
    );
  }
}
