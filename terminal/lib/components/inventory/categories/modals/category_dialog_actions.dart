import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Modal dialog action buttons for Cancel and Submit category.
class CategoryDialogActions extends StatelessWidget {
  final bool isSubmitting;
  final bool isEditing;
  final VoidCallback onSubmit;

  const CategoryDialogActions({
    super.key,
    required this.isSubmitting,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: () => Navigator.of(context).pop(),
            style: BoxStyler()
                .color(const Color(0xFFFFFFFF))
                .borderAll(color: const Color(0xFFE2E8F0))
                .paddingX(16)
                .height(42)
                .borderRadiusAll(const Radius.circular(10))
                .alignment(Alignment.center)
                .onHovered(BoxStyler().color(const Color(0xFFF8FAFC))),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ),
        const Gap(10),
        MouseRegion(
          cursor: isSubmitting
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: PressableBox(
            onPress: isSubmitting ? () {} : onSubmit,
            style: BoxStyler()
                .color(TerminalColors.primary)
                .paddingX(20)
                .height(42)
                .borderRadiusAll(const Radius.circular(10))
                .alignment(Alignment.center)
                .onHovered(
                  isSubmitting
                      ? BoxStyler()
                      : BoxStyler().color(TerminalColors.primaryHover),
                ),
            child: Text(
              isSubmitting
                  ? 'Saving...'
                  : (isEditing ? 'Save Changes' : 'Create Category'),
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
