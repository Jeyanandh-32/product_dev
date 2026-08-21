import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/online_order_checkout_coordinator.dart';
import 'package:backend/services/online_payment_calculator.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;
import 'package:validators/validators.dart';

/// Initiates online PhonePe payment session or direct wallet checkout for online orders.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  try {
    final body = await context.validateBody(OrderValidator.create);
    final input = OrderCreate.fromJson(body);
    final orderService = context.read<OrderService>();
    final customerRepo = context.read<CustomerRepository>();
    final tokenPayload = context.tokenPayload;
    final db = Database.db;
    final phonePeService = PhonePeService();

    final storeFuture = db.stores.where((s) => s.id.equals(toExpr(context.storeId))).first.fetch();
    final phonePeFuture = db.storePhonepeConfigs
        .where((c) => c.storeId.equals(toExpr(context.storeId)) & c.isEnabled.equals(toExpr(true)))
        .first
        .fetch();

    final (storeRow, phonePeConfigRow) = await (storeFuture, phonePeFuture).wait;

    if (storeRow == null || !storeRow.isOnlineEnabled) {
      return badRequest(message: 'Online ordering is currently disabled for this store.');
    }

    if (phonePeConfigRow == null) {
      return badRequest(message: 'Online checkout configuration is incomplete for this store.');
    }

    final phonePeConfig = phonePeConfigRow.toStorePhonePeConfig();

    final productsList = input.products
        .map((p) => {'productId': p.productId, 'quantity': p.quantity, 'discount': p.discount})
        .toList();

    final calc = await OnlinePaymentCalculator.computeAmounts(
      orderService: orderService,
      customerRepo: customerRepo,
      customerId: tokenPayload.sub,
      storeId: context.storeId,
      productsList: productsList,
      discountTotal: input.discountTotal ?? 0.0,
      useWallet: input.useWallet ?? false,
    );

    if (calc.remainingPayablePaise <= 0) {
      return await OnlineOrderCheckoutCoordinator.handleWalletOnlyOrder(
        orderService: orderService,
        customerRepo: customerRepo,
        merchantId: storeRow.merchantId,
        storeId: context.storeId,
        customerId: tokenPayload.sub,
        productsList: productsList,
        discountTotal: input.discountTotal ?? 0.0,
        walletDeductionPaise: calc.actualWalletDeductionPaise,
      );
    }

    return await OnlineOrderCheckoutCoordinator.handlePhonePeHybridOrder(
      orderService: orderService,
      customerRepo: customerRepo,
      phonePeService: phonePeService,
      phonePeConfig: phonePeConfig,
      context: context,
      merchantId: storeRow.merchantId,
      storeId: context.storeId,
      customerId: tokenPayload.sub,
      productsList: productsList,
      discountTotal: input.discountTotal ?? 0.0,
      walletDeductionPaise: calc.actualWalletDeductionPaise,
      remainingPayablePaise: calc.remainingPayablePaise,
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
