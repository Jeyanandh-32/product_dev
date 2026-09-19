import 'package:api_client/api_client.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:terminal/components/orders/order_details_modal.dart';
import 'package:terminal/components/scanner/order_qr_code_parser.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/orders_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Handles scanned barcode events, order lookup, and UI navigation transitions.
abstract final class OrderQrScannerHandler {
  /// Processes a scanned raw QR string [rawBarcode].
  static Future<void> processBarcode({
    required BuildContext context,
    required String rawBarcode,
    required ValueNotifier<bool> isProcessingNotifier,
  }) async {
    if (isProcessingNotifier.value) return;
    isProcessingNotifier.value = true;

    HapticFeedback.mediumImpact().ignore();

    final code = OrderQrCodeParser.parse(rawBarcode);
    if (code == null || code.isEmpty) {
      if (context.mounted) {
        TerminalToast.showError(
          context: context,
          title: 'Invalid Order QR',
          description: 'Please scan a valid order reference QR code (ORD-XXXX).',
        );
      }
      isProcessingNotifier.value = false;
      return;
    }

    final terminal = authSignal.value.value;
    final storeId = terminal?.storeId;
    if (storeId == null) {
      if (context.mounted) {
        TerminalToast.showError(
          context: context,
          title: 'Session Error',
          description: 'Active store terminal session not found.',
        );
      }
      isProcessingNotifier.value = false;
      return;
    }

    // Fast-path: Check loaded in-memory orders strictly by orderReference
    final localOrder = ordersSignal.value.value?.where((o) {
      return o.orderReference.toLowerCase() == code.toLowerCase();
    }).firstOrNull;

    if (localOrder != null) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      await OrderDetailsModal.show(context, localOrder);
      isProcessingNotifier.value = false;
      return;
    }

    try {
      final order =
          await OrderRepository.getByIdOrReference(storeId: storeId, id: code);
      if (!context.mounted) return;

      Navigator.of(context).pop();
      await OrderDetailsModal.show(context, order);
      isProcessingNotifier.value = false;
    } on ApiException catch (e) {
      if (context.mounted) {
        final isDbSyntaxError = e.message.contains('22P02') ||
            e.message.contains('invalid input syntax');
        TerminalToast.showError(
          context: context,
          title: 'Order Not Found',
          description: isDbSyntaxError
              ? 'Could not find order for reference "$code".'
              : e.message,
        );
      }
      isProcessingNotifier.value = false;
    } catch (_) {
      if (context.mounted) {
        TerminalToast.showError(
          context: context,
          title: 'Order Not Found',
          description: 'Could not retrieve order for "$code".',
        );
      }
      isProcessingNotifier.value = false;
    }
  }
}
