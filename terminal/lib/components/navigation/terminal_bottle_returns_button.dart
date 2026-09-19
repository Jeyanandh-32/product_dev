import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_dialog.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Top header quick action button for opening the manual bottle return acceptance modal.
class TerminalBottleReturnsButton extends StatefulWidget {
  const TerminalBottleReturnsButton({super.key});

  @override
  State<TerminalBottleReturnsButton> createState() =>
      _TerminalBottleReturnsButtonState();
}

class _TerminalBottleReturnsButtonState
    extends State<TerminalBottleReturnsButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final cfg = bottleReturnConfigSignal.value;
        if (cfg == null || !cfg.isEnabled) return const SizedBox.shrink();

        final isCompact = context.screenWidth < 800;
        final fgColor =
            _isHovered ? const Color(0xFFFFFFFF) : const Color(0xFF16A34A);
        final bgColor =
            _isHovered ? const Color(0xFF16A34A) : const Color(0xFFF0FDF4);
        final borderColor =
            _isHovered ? const Color(0xFF16A34A) : const Color(0xFFBBF7D0);

        final baseStyle = BoxStyler()
            .height(38)
            .paddingX(isCompact ? 0 : 12)
            .borderRadiusAll(const Radius.circular(999))
            .color(bgColor)
            .borderAll(color: borderColor)
            .shadowOnly(
              color: const Color(0x06000000),
              offset: const Offset(0, 1),
              blurRadius: 2,
            )
            .alignment(Alignment.center);

        final buttonStyle = isCompact ? baseStyle.width(38) : baseStyle;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: PressableBox(
              onPress: () => AcceptBottleReturnsDialog.show(context),
              style: buttonStyle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FLucideIcons.recycle, size: 16, color: fgColor),
                  if (!isCompact) ...[
                    const Gap(6),
                    Text(
                      'Accept Returns',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: fgColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

