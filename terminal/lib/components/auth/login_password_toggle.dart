import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// Clickable eye toggle icon for password field obscurity state.
class LoginPasswordToggle extends StatelessWidget {
  final bool obscure;
  final VoidCallback onToggle;

  const LoginPasswordToggle({
    super.key,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onToggle,
        child: Icon(
          obscure ? FLucideIcons.eyeOff : FLucideIcons.eye,
          size: 16,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }
}
