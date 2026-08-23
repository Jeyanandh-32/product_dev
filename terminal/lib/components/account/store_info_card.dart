import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/account/account_card_header.dart';
import 'package:terminal/components/account/account_info_row.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Card displaying assigned store details and operational status.
class StoreInfoCard extends StatelessWidget {
  final Store? store;

  const StoreInfoCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final storeData = store;

    if (storeData == null) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TerminalColors.border),
        ),
        padding: const EdgeInsets.all(22),
        child: const Center(
          child: Text(
            'Store details unavailable.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TerminalColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountCardHeader(
            icon: FLucideIcons.store,
            title: 'Assigned Store',
            subtitle: 'Branch & operational settings',
            isActive: storeData.isActive,
          ),
          const Gap(18),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const Gap(16),
          AccountInfoRow(
            label: 'Store Name',
            value: storeData.name,
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Store Category',
            value: storeData.storeType?.toUpperCase() ?? 'RETAIL',
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Online Ordering',
            value: storeData.isOnlineEnabled ? 'Enabled & Accepting Orders' : 'Disabled',
            isSuccess: storeData.isOnlineEnabled,
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Store Slug',
            value: storeData.slug ?? 'Not configured',
            isMonospace: storeData.slug != null,
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Created On',
            value: _formatDate(storeData.createdAt),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
  }
}
