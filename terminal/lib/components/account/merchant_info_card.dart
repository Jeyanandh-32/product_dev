import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/account/account_card_header.dart';
import 'package:terminal/components/account/account_info_row.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Card displaying merchant enterprise and owner contact details.
class MerchantInfoCard extends StatelessWidget {
  final Merchant? merchant;

  const MerchantInfoCard({super.key, required this.merchant});

  @override
  Widget build(BuildContext context) {
    final merchantData = merchant;

    if (merchantData == null) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TerminalColors.border),
        ),
        padding: const EdgeInsets.all(22),
        child: const Center(
          child: Text(
            'Merchant details unavailable.',
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
          const AccountCardHeader(
            icon: FLucideIcons.building2,
            title: 'Merchant Enterprise',
            subtitle: 'Organization & owner contacts',
          ),
          const Gap(18),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const Gap(16),
          AccountInfoRow(
            label: 'Business Name',
            value: merchantData.businessName,
          ),
          const Gap(14),
          AccountInfoRow(label: 'Owner Name', value: merchantData.name),
          const Gap(14),
          AccountInfoRow(label: 'Contact Email', value: merchantData.email),
          const Gap(14),
          AccountInfoRow(
            label: 'WhatsApp Phone',
            value: merchantData.whatsappNumber,
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Member Since',
            value: _formatDate(merchantData.createdAt),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
