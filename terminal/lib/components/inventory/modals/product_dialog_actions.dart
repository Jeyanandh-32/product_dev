import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Modal footer action buttons for Cancel and Submit.
class ProductDialogActions extends StatelessWidget {
  final bool isSubmitting;
  final bool isEditing;
  final VoidCallback onSubmit;

  const ProductDialogActions({
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
            style: BoxStyler().paddingX(14).paddingY(8).borderRadiusAll(const Radius.circular(9)).color(const Color(0xFFFFFFFF)).onHovered(BoxStyler().color(const Color(0xFFF1F5F9))),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
          ),
        ),
        const Gap(10),
        MouseRegion(
          cursor: isSubmitting ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: PressableBox(
            onPress: isSubmitting ? null : onSubmit,
            style: BoxStyler().paddingX(18).paddingY(9).borderRadiusAll(const Radius.circular(10)).color(const Color(0xFF000000)).onHovered(BoxStyler().color(const Color(0xFF1E293B))),
            child: isSubmitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(isEditing ? 'Save Changes' : 'Create Product', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFFFFFFF))),
          ),
        ),
      ],
    );
  }
}
