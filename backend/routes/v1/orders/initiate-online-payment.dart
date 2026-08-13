import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return methodNotAllowed();
  }

  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  try {
    final body = await context.validateBody(OrderValidator.create);
    final input = OrderCreate.fromJson(body);
    final orderService = context.read<OrderService>();
    final tokenPayload = context.tokenPayload;
    final db = Database.db;
    final phonePeService = PhonePeService();

    // 1. Verify store online ordering is enabled and fetch phonepe config
    final storeRow = await db.stores
        .where((s) => s.id.equals(toExpr(context.storeId)))
        .first
        .fetch();

    if (storeRow == null || !storeRow.isOnlineEnabled) {
      return error(message: 'Online ordering is currently disabled for this store.', statusCode: 400);
    }

    final phonePeConfigRow = await db.storePhonepeConfigs
        .where((c) => c.storeId.equals(toExpr(context.storeId)) & c.isEnabled.equals(toExpr(true)))
        .first
        .fetch();

    if (phonePeConfigRow == null) {
      return error(message: 'Online checkout configuration is incomplete for this store.', statusCode: 400);
    }

    final phonePeConfig = phonePeConfigRow.toStorePhonePeConfig();

    final productsList = input.products
        .map(
          (p) => {
            'productId': p.productId,
            'quantity': p.quantity,
            'discount': p.discount,
          },
        )
        .toList();

    // 2. Checkout order as pending & unpaid
    final completeOrder = await orderService.checkout(
      merchantId: storeRow.merchantId,
      storeId: context.storeId,
      productsInput: productsList,
      source: OrderSource.web,
      type: OrderType.takeaway,
      paymentMethod: PaymentMethod.upi,
      status: OrderStatus.pending,
      paymentStatus: PaymentStatus.pending,
      discountTotalInput: input.discountTotal ?? 0.0,
      customerId: tokenPayload.sub,
    );

    // Amount in paisa
    final amountInPaisa = (completeOrder.grandTotal * 100).round();
    final merchantOrderId = completeOrder.orderReference;
    final redirectUrl = '${context.request.uri.scheme}://${context.request.uri.authority}/order/status?reference=$merchantOrderId';

    // 3. Initiate PhonePe checkout session
    final paymentSession = await phonePeService.initiatePayment(
      config: phonePeConfig,
      merchantOrderId: merchantOrderId,
      amountInPaisa: amountInPaisa,
      redirectUrl: redirectUrl,
      storeId: context.storeId,
    );

    return success(
      data: {
        'order': completeOrder,
        'tokenUrl': paymentSession.tokenUrl,
        'phonePeOrderId': paymentSession.orderId,
        'merchantOrderId': merchantOrderId,
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
