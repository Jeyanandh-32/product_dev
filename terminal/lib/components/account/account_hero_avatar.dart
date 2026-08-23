import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// Circular avatar with verified badge overlay for account hero banners.
class AccountHeroAvatar extends StatelessWidget {
  final String initials;

  const AccountHeroAvatar({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FLucideIcons.badgeCheck,
              size: 14,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ],
    );
  }
}
