import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

/// Reusable key-value row for account information cards with enhanced text readability and contrast.
class AccountInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMonospace;
  final bool? isSuccess;
  final Widget? trailing;

  const AccountInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isMonospace = false,
    this.isSuccess,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Color valColor = const Color(0xFF0F172A);
    if (isSuccess == true) valColor = const Color(0xFF15803D);
    if (isSuccess == false) valColor = const Color(0xFF475569);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
            letterSpacing: -0.1,
          ),
        ),
        const Gap(16),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valColor,
                    fontFamily: isMonospace ? 'monospace' : null,
                    letterSpacing: isMonospace ? 0.4 : -0.1,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const Gap(8),
                trailing!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
