import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

/// Clean status badge pill with high contrast typography and live dot indicator.
class AccountStatusBadge extends StatelessWidget {
  final bool isActive;
  final String? label;

  const AccountStatusBadge({
    super.key,
    required this.isActive,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final text = label ?? (isActive ? 'ACTIVE POS' : 'INACTIVE');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF16A34A) : const Color(0xFF64748B),
              shape: BoxShape.circle,
            ),
          ),
          const Gap(5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: isActive ? const Color(0xFF14532D) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
