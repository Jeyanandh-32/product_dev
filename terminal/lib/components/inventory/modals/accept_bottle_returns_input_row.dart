import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';

/// Text field and trigger button for manually adding bottle return tokens.
class AcceptBottleReturnsInputRow extends StatelessWidget {
  const AcceptBottleReturnsInputRow({
    required this.controller,
    required this.onAdd,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(
                  FLucideIcons.qrCode,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const Gap(8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => onAdd(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Scan or type bottle token ID...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressableBox(
            onPress: onAdd,
            style: BoxStyler()
                .height(42)
                .paddingX(16)
                .borderRadiusAll(const Radius.circular(10))
                .color(const Color(0xFF0F172A))
                .alignment(Alignment.center)
                .onHovered(BoxStyler().color(const Color(0xFF334155))),
            child: const Text(
              'Add Token',
              style: TextStyle(
                fontSize: 12.5,
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
