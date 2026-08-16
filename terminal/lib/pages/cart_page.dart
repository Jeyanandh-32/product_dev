import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Dedicated full-screen Cart page for mobile and compact tablet devices using customer app theme.
class CartPage extends SignalWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cart = cartSignal.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 12),
            child: _CartBackButton(),
          ),
        ),
        title: StyledText(
          'Order Items',
          style: TextStyler()
              .fontSize(18)
              .fontWeight(.w800)
              .color(theme.colors.primary),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: theme.colors.border, height: 1.0),
        ),
        actions: [
          if (cart.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: () => CartController.clear(),
                    style: BoxStyler()
                        .paddingX(14)
                        .paddingY(6)
                        .borderRadiusAll(const Radius.circular(999))
                        .color(const Color(0xFFFEF2F2))
                        .borderAll(color: const Color(0xFFFECACA))
                        .textStyle(
                          TextStyler()
                              .fontSize(12)
                              .fontWeight(.w800)
                              .color(const Color(0xFFDC2626)),
                        )
                        .onHovered(
                          BoxStyler()
                              .color(const Color(0xFFDC2626))
                              .borderAll(color: const Color(0xFFDC2626))
                              .textStyle(TextStyler().color(Colors.white)),
                        )
                        .onPressed(BoxStyler().scale(0.96)),
                    child: const StyledText('Clear All'),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: const SafeArea(
        child: Cart(isDrawerMode: true),
      ),
    );
  }
}

/// Circular back navigation button matching the customer web app header style.
class _CartBackButton extends StatefulWidget {
  const _CartBackButton();

  @override
  State<_CartBackButton> createState() => _CartBackButtonState();
}

class _CartBackButtonState extends State<_CartBackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.pop(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.black : const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              FLucideIcons.arrowLeft,
              size: 18,
              color: _isHovered ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
