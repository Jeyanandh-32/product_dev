import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Edit and update stock action button pair for inventory data table rows.
class InventoryActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onUpdateStock;
  final Key? editKey;

  const InventoryActionButtons({
    super.key,
    required this.onEdit,
    required this.onUpdateStock,
    this.editKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionBtn(FLucideIcons.squarePen, onEdit, key: editKey),
        const Gap(5),
        _buildActionBtn(FLucideIcons.boxes, onUpdateStock),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, VoidCallback onTap, {Key? key}) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: PressableBox(
          key: key,
          onPress: onTap,
          style: BoxStyler()
              .width(30)
              .height(30)
              .borderRadiusAll(const Radius.circular(8))
              .color(TerminalColors.secondaryBackground)
              .alignment(Alignment.center)
              .onHovered(BoxStyler().color(TerminalColors.controlHover)),
          child: Icon(icon, size: 14.5, color: TerminalColors.textLight),
        ),
      );
}
