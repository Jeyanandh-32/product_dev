import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/components.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Account and device profile page using Forui and Mix.
class AccountPage extends SignalWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final terminal = authSignal.value.value;

    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: const Text('Device Account'),
        prefixes: const [
          TerminalBackButton(),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Box(
              style: BoxStyler()
                  .color(const Color(0xFFFFFFFF))
                  .borderRadiusAll(const Radius.circular(16))
                  .paddingAll(24)
                  .borderAll(color: const Color(0xFFE5E7EB))
                  .shadowOnly(
                    color: const Color(0x0A000000),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Box(
                      style: BoxStyler()
                          .width(72)
                          .height(72)
                          .borderRadiusAll(const Radius.circular(999))
                          .color(const Color(0xFFF3F4F6))
                          .alignment(Alignment.center),
                      child: const Icon(
                        FLucideIcons.monitor,
                        size: 32,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Center(
                    child: StyledText(
                      terminal?.name ?? 'Terminal POS',
                      style: TextStyler()
                          .fontSize(18)
                          .fontWeight(.w800)
                          .color(const Color(0xFF000000)),
                    ),
                  ),
                  const Gap(4),
                  Center(
                    child: StyledText(
                      'Code: ${terminal?.code ?? 'N/A'}',
                      style: TextStyler()
                          .fontSize(13)
                          .fontWeight(.w600)
                          .color(const Color(0xFF6B7280)),
                    ),
                  ),
                  const Gap(24),
                  const FDivider(),
                  const Gap(16),
                  _infoRow('Store ID', terminal?.storeId ?? 'N/A'),
                  const Gap(12),
                  _infoRow('Status', terminal?.isActive == true ? 'Active' : 'Inactive'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StyledText(
          label,
          style: TextStyler()
              .fontSize(13)
              .fontWeight(.w500)
              .color(const Color(0xFF6B7280)),
        ),
        StyledText(
          value,
          style: TextStyler()
              .fontSize(13)
              .fontWeight(.w700)
              .color(const Color(0xFF000000)),
        ),
      ],
    );
  }
}
