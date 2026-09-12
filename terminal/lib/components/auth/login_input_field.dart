import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terminal/components/auth/login_field_error.dart';
import 'package:terminal/components/auth/login_password_toggle.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Clean styled 42px login text input field with error validation and focus styling.
class LoginInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final bool isPassword;
  final bool autofocus;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;

  const LoginInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.focusNode,
    this.isPassword = false,
    this.autofocus = false,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.validator,
    this.onSubmitted,
    this.onEditingComplete,
    this.onChanged,
  });

  @override
  State<LoginInputField> createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField> {
  FocusNode? _internalFocusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());
  bool _isFocused = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _isFocused = _effectiveFocusNode.hasFocus;
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(LoginInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _onFocusChange,
      );
      _effectiveFocusNode.addListener(_onFocusChange);
      _isFocused = _effectiveFocusNode.hasFocus;
    }
  }

  void _onFocusChange() {
    if (mounted && _isFocused != _effectiveFocusNode.hasFocus) {
      setState(() => _isFocused = _effectiveFocusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    (widget.focusNode ?? _internalFocusNode)?.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => widget.validator?.call(widget.controller.text),
      builder: (state) {
        final hasError = state.hasError;
        final borderCol = hasError
            ? const Color(0xFFDC2626)
            : (_isFocused ? TerminalColors.primary : TerminalColors.border);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: borderCol,
                  width: _isFocused || hasError ? 1.5 : 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _effectiveFocusNode,
                      controller: widget.controller,
                      autofocus: widget.autofocus,
                      obscureText: widget.isPassword ? _obscure : false,
                      textInputAction: widget.textInputAction,
                      inputFormatters: widget.inputFormatters,
                      onSubmitted: widget.onSubmitted,
                      onEditingComplete: widget.onEditingComplete,
                      onChanged: (v) {
                        if (state.hasError) state.validate();
                        widget.onChanged?.call(v);
                      },
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: widget.hint,
                        hintStyle: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  if (widget.isPassword)
                    LoginPasswordToggle(
                      obscure: _obscure,
                      onToggle: () => setState(() => _obscure = !_obscure),
                    ),
                ],
              ),
            ),
            LoginFieldError(errorText: state.errorText),
          ],
        );
      },
    );
  }
}
