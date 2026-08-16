import 'package:flutter/material.dart';

/// Interactive circular button for steppers matching customer web app:
/// `w-7 h-7 rounded-full bg-white hover:bg-black hover:text-white text-black font-bold shadow-2xs`
class StepperCircleButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final double size;
  final VoidCallback onTap;

  const StepperCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconSize = 13,
    this.size = 28,
  });

  @override
  State<StepperCircleButton> createState() => _StepperCircleButtonState();
}

class _StepperCircleButtonState extends State<StepperCircleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered ? Colors.black : Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: _isHovered ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
