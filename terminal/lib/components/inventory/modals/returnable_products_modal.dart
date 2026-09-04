import 'package:flutter/material.dart';
import 'package:terminal/components/inventory/modals/returnable_products_body.dart';

/// Modal for managing store returnable bottle products and bulk toggling.
class ReturnableProductsModal extends StatelessWidget {
  const ReturnableProductsModal({super.key});

  /// Displays the Returnable Products management dialog.
  static Future<void> show(BuildContext context) => showDialog(
    context: context,
    builder: (_) => const ReturnableProductsModal(),
  );

  @override
  Widget build(BuildContext context) {
    final dialogHeight = (MediaQuery.sizeOf(context).height * 0.88).clamp(
      400.0,
      680.0,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 540, maxHeight: dialogHeight),
        child: SizedBox(
          width: double.infinity,
          height: dialogHeight,
          child: const Padding(
            padding: EdgeInsets.all(22),
            child: ReturnableProductsBody(),
          ),
        ),
      ),
    );
  }
}
