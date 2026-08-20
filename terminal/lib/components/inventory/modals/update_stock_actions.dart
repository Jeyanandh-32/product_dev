import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Modal footer action buttons for Update Stock modal matching Terminal monochrome design.
class UpdateStockActions extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const UpdateStockActions({
    super.key,
    required this.isSubmitting,
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
                .height(42)
                .paddingX(18)
                .borderRadiusAll(const Radius.circular(12))
                .color(const Color(0xFFF1F5F9))
                .alignment(Alignment.center)
                .onHovered(BoxStyler().color(const Color(0xFFE2E8F0))),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w700, fontSize: 13.5)),
          ),
        ),
        const Gap(10),
        MouseRegion(
          cursor: isSubmitting ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: PressableBox(
            onPress: isSubmitting ? null : onSubmit,
            style: BoxStyler()
                .height(42)
                .paddingX(22)
                .borderRadiusAll(const Radius.circular(12))
                .color(const Color(0xFF000000))
                .alignment(Alignment.center)
                .onHovered(BoxStyler().color(const Color(0xFF1E293B))),
            child: isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Update Stock', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF), fontSize: 13.5)),
          ),
        ),
      ],
    );
  }
}
