import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:terminal/components/account/account_card_header.dart';
import 'package:terminal/components/account/account_info_row.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Card displaying authenticated POS terminal device details.
class TerminalInfoCard extends StatelessWidget {
  final Terminal terminal;

  const TerminalInfoCard({super.key, required this.terminal});

  void _copyTerminalCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: terminal.code));
    TerminalToast.showSuccess(
      context: context,
      title: 'Copied',
      description: 'Terminal code copied to clipboard.',
    );
  }

  @override
  Widget build(BuildContext context) {
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
      padding: EdgeInsets.all(context.isMobile ? 14 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountCardHeader(
            icon: FLucideIcons.monitor,
            title: 'Terminal Hardware',
            subtitle: 'Device & workstation profile',
          ),
          const Gap(18),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const Gap(16),
          AccountInfoRow(label: 'Terminal Name', value: terminal.name),
          const Gap(14),
          AccountInfoRow(
            label: 'Terminal Code',
            value: terminal.code,
            isMonospace: true,
            trailing: GestureDetector(
              onTap: () => _copyTerminalCode(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  FLucideIcons.copy,
                  size: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Store ID',
            value: terminal.storeId,
            isMonospace: true,
          ),
          const Gap(14),
          AccountInfoRow(
            label: 'Registered On',
            value: _formatDate(terminal.createdAt),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
