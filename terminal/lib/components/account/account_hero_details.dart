import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Responsive subtitle details for the account hero banner.
class AccountHeroDetails extends StatelessWidget {
  final Store? store;
  final Merchant? merchant;

  const AccountHeroDetails({
    super.key,
    required this.store,
    required this.merchant,
  });

  @override
  Widget build(BuildContext context) {
    final storeName = store?.name ?? 'Assigned Store';
    final merchantName = merchant?.businessName;

    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FLucideIcons.store,
                size: 14,
                color: Color(0xFF64748B),
              ),
              const Gap(6),
              Expanded(
                child: Text(
                  storeName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (merchantName != null) ...[
            const Gap(4),
            Row(
              children: [
                const Icon(
                  FLucideIcons.building2,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                const Gap(6),
                Expanded(
                  child: Text(
                    merchantName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    }

    return Row(
      children: [
        const Icon(FLucideIcons.store, size: 14, color: Color(0xFF64748B)),
        const Gap(5),
        Flexible(
          child: Text(
            storeName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (merchantName != null) ...[
          const Gap(8),
          const Text(
            '•',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          const Icon(
            FLucideIcons.building2,
            size: 14,
            color: Color(0xFF64748B),
          ),
          const Gap(5),
          Flexible(
            child: Text(
              merchantName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
