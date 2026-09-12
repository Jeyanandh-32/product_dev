import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Reusable clean styled text input field with exact 42px container height.
class ModalInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final bool isRequired;
  final String? prefixText;

  const ModalInputField({
    super.key,
    required this.label,
    this.hint,
    required this.value,
    required this.onChanged,
    this.keyboardType,
    this.isRequired = false,
    this.prefixText,
  });

  @override
  State<ModalInputField> createState() => _ModalInputFieldState();
}

class _ModalInputFieldState extends State<ModalInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted && _isFocused != _focusNode.hasFocus) {
        setState(() => _isFocused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayLabel = widget.isRequired ? '${widget.label}*' : widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayLabel,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: widget.isRequired
                ? const Color(0xFF0F172A)
                : const Color(0xFF334155),
          ),
        ),
        const Gap(7),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isFocused
                  ? TerminalColors.primary
                  : TerminalColors.border,
              width: _isFocused ? 1.5 : 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.prefixText case final prefix?) ...[
                Text(
                  prefix,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const Gap(6),
              ],
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  initialValue: widget.value,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
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
            ],
          ),
        ),
      ],
    );
  }
}
