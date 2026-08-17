import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/components.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Dedicated full-screen Cart page for mobile and compact tablet devices using Forui.
class CartPage extends SignalWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = cartSignal.value;

    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: const Text('Order Items'),
        prefixes: [
          FHeaderAction.back(
            onPress: () => GoRouter.maybeOf(context)?.pop(),
          ),
        ],
        suffixes: [
          if (cart.items.isNotEmpty) const CartClearAllButton(),
        ],
      ),
      child: const Cart(isDrawerMode: true),
    );
  }
}
