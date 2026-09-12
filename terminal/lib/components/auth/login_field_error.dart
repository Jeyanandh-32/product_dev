import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

/// Form validation error message displayed below login text inputs.
class LoginFieldError extends StatelessWidget {
  final String? errorText;

  const LoginFieldError({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    final text = errorText;
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }
}
