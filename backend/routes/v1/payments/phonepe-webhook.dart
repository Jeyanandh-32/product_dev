import 'dart:convert';
import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  try {
    final rawBody = await context.request.body();
    final json = jsonDecode(rawBody) as Map<String, dynamic>;
    final event = json['event'] as String?;
    final payload = json['payload'] as Map<String, dynamic>?;

    if (event == null || payload == null) {
      return badRequest(message: 'Invalid webhook payload structure');
    }

    final merchantOrderId = payload['merchantOrderId'] as String?;
    final state = payload['state'] as String?;
    final metaInfo = payload['metaInfo'] as Map<String, dynamic>?;
    final storeId = metaInfo?['udf1'] as String?;

    if (merchantOrderId == null || state == null) {
      return badRequest(message: 'Missing required webhook payload fields');
    }

    final db = Database.db;
    final phonePeService = PhonePeService();

    // Verify HMAC signature if secret key is present
    if (storeId != null && storeId.isNotEmpty) {
      final configRow = await db.storePhonepeConfigs
          .where((c) => c.storeId.equals(toExpr(storeId)))
          .first
          .fetch();

      if (configRow?.webhookSecretKey case final secretKey?
          when secretKey.isNotEmpty) {
        final signatureHeader =
            context.request.headers['x-phonepe-checksum-signature'] ?? '';
        final isValid = phonePeService.verifyWebhookHmac(
          rawRequestBody: rawBody,
          signatureHeader: signatureHeader,
          secretKey: secretKey,
        );
        if (!isValid) {
          return error(message: 'Invalid webhook signature', statusCode: 401);
        }
      }
    }

    final gatewayState = PhonePeGatewayState.tryParse(state);
    final isCompleted =
        (gatewayState?.isSuccess ?? false) || event == 'checkout.order.completed';
    final isFailed =
        (gatewayState?.isFailed ?? false) || event == 'checkout.order.failed';

    // Process order or wallet top-up update based on event & state
    if (merchantOrderId.startsWith('TOPUP_')) {
      final customerRepo = CustomerRepository(db: Database.db);
      final txRow = await Database.db.customerWalletTransactions
          .where((t) => t.reference.equals(toExpr(merchantOrderId)))
          .first
          .fetch();

      if (txRow != null && txRow.status == 'pending') {
        if (isCompleted) {
          await customerRepo.updateStoreWalletBalance(
            customerId: txRow.customerId,
            storeId: txRow.storeId,
            amountDeltaPaise: txRow.amount,
          );
          await customerRepo.updateWalletTransactionStatus(
            id: txRow.id,
            status: 'completed',
          );
        } else if (isFailed) {
          await customerRepo.updateWalletTransactionStatus(
            id: txRow.id,
            status: 'failed',
          );
        }
      }
    } else {
      final orderRow = await Database.db.orders
          .where((o) => o.orderReference.equals(toExpr(merchantOrderId)))
          .first
          .fetch();

      if (orderRow != null) {
        final db = Database.db;
        final orderRepo = OrderRepository(db: db);
        final itemRows = await OrderItemRepository(db: db).getAllForOrder(orderRow.id);
        final orderService = OrderService(
          orderRepo: orderRepo,
          orderItemRepo: OrderItemRepository(db: db),
          productRepo: ProductRepository(db: db),
          stockRepo: StockRepository(db: db),
        );

        if (isCompleted) {
          await orderService.completeOrderPayment(
            orderRow: orderRow,
            orderItems: itemRows,
          );
        } else if (isFailed) {
          await orderService.cancelOrder(
            orderRow: orderRow,
          );
        }
      }
    }

    return success(data: {'received': true});
  } catch (e) {
    return error(message: e.toString());
  }
}
