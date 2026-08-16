import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/stepper_circle_button.dart';
import 'package:terminal/models/cart_item.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Single item card in the POS cart list with customer hover border animation.
class CartItemRow extends StatefulWidget {
  final CartItem item;

  const CartItemRow({super.key, required this.item});

  @override
  State<CartItemRow> createState() => _CartItemRowState();
}

class _CartItemRowState extends State<CartItemRow> {
  bool _isCardHovered = false;
  bool _isTrashHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isCardHovered = true),
      onExit: (_) => setState(() => _isCardHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isCardHovered ? Colors.black : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isCardHovered ? 0.06 : 0.03),
              offset: const Offset(0, 2),
              blurRadius: _isCardHovered ? 6 : 3,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image / Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 56,
                height: 56,
                color: const Color(0xFFF3F4F6),
                child: widget.item.product.imageUrl != null &&
                        widget.item.product.imageUrl!.trim().isNotEmpty
                    ? Image.network(
                        widget.item.product.imageUrl!.trim(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(
                            FLucideIcons.store,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          FLucideIcons.store,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${widget.item.product.sellingPrice.toStringAsFixed(2)} × ${widget.item.quantity}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${(widget.item.product.sellingPrice * widget.item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Stepper Pill (- qty +) and Trash Action
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StepperCircleButton(
                        icon: FLucideIcons.minus,
                        size: 26,
                        iconSize: 12,
                        onTap: () => CartController.updateQuantity(
                          widget.item.product.id,
                          widget.item.quantity - 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${widget.item.quantity}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      StepperCircleButton(
                        icon: FLucideIcons.plus,
                        size: 26,
                        iconSize: 12,
                        onTap: () => CartController.updateQuantity(
                          widget.item.product.id,
                          widget.item.quantity + 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isTrashHovered = true),
                  onExit: (_) => setState(() => _isTrashHovered = false),
                  child: GestureDetector(
                    onTap: () => CartController.removeItem(widget.item.product.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isTrashHovered ? const Color(0xFFDC2626) : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        FLucideIcons.trash2,
                        size: 16,
                        color: _isTrashHovered ? Colors.white : const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
