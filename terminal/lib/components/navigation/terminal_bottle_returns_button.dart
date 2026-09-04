import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_dialog.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Top header quick action button for opening the manual bottle return acceptance modal.
class TerminalBottleReturnsButton extends StatelessWidget {
  const TerminalBottleReturnsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final cfg = bottleReturnConfigSignal.value;
        if (cfg == null || !cfg.isEnabled) return const SizedBox.shrink();

        final isCompact = context.screenWidth < 840;

        final buttonStyle = BoxStyler()
            .height(36)
            .paddingX(isCompact ? 10 : 12)
            .borderRadiusAll(const Radius.circular(10))
            .color(const Color(0xFFF0FDF4))
            .borderAll(color: const Color(0xFFBBF7D0), width: 1)
            .alignment(Alignment.center)
            .onHovered(
              BoxStyler()
                  .color(const Color(0xFFDCFCE7))
                  .borderAll(color: const Color(0xFF86EFAC), width: 1),
            );

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: PressableBox(
              onPress: () => AcceptBottleReturnsDialog.show(context),
              style: buttonStyle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FLucideIcons.recycle, size: 14, color: Color(0xFF16A34A)),
                  const Gap(6),
                  Text(
                    isCompact ? 'Returns' : 'Accept Returns',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
