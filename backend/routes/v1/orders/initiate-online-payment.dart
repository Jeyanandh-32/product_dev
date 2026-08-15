import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/online_payment_calculator.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;
import 'package:validators/validators.dart';

/// Initiates online PhonePe payment session or direct wallet checkout for online orders.
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
    final customerRepo = context.read<CustomerRepository>();
    final tokenPayload = context.tokenPayload;
    final db = Database.db;
    final phonePeService = PhonePeService();

    final storeRow = await db.stores
        .where((s) => s.id.equals(toExpr(context.storeId)))
        .first
        .fetch();

    if (storeRow == null || !storeRow.isOnlineEnabled) {
      return badRequest(
        message: 'Online ordering is currently disabled for this store.',
      );
    }

    final phonePeConfigRow = await db.storePhonepeConfigs
        .where(
          (c) =>
              c.storeId.equals(toExpr(context.storeId)) &
              c.isEnabled.equals(toExpr(true)),
        )
        .first
        .fetch();

    if (phonePeConfigRow == null) {
      return badRequest(
        message: 'Online checkout configuration is incomplete for this store.',
      );
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

    final calc = await OnlinePaymentCalculator.computeAmounts(
      orderService: orderService,
      customerRepo: customerRepo,
      customerId: tokenPayload.sub,
      storeId: context.storeId,
      productsList: productsList,
      discountTotal: input.discountTotal ?? 0.0,
      useWallet: input.useWallet ?? false,
    );

    // If 100% covered by Wallet -> Create single completed order immediately
    if (calc.remainingPayablePaise <= 0) {
      final completedOrder = await orderService.checkout(
        merchantId: storeRow.merchantId,
        storeId: context.storeId,
        productsInput: productsList,
        source: OrderSource.web,
        type: OrderType.takeaway,
        paymentMethod: PaymentMethod.upi,
        status: OrderStatus.pending,
        discountTotalInput: input.discountTotal ?? 0.0,
        walletDeductionInput: calc.actualWalletDeductionPaise / 100.0,
        customerId: tokenPayload.sub,
      );

      await customerRepo.updateStoreWalletBalance(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amountDeltaPaise: -calc.actualWalletDeductionPaise,
      );

      await customerRepo.createWalletTransaction(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amount: calc.actualWalletDeductionPaise,
        type: WalletTransactionType.orderDebit.name,
        reference: completedOrder.orderReference,
      );

      return success(
        data: {
          'order': completedOrder,
          'tokenUrl': null,
          'phonePeOrderId': null,
          'merchantOrderId': completedOrder.orderReference,
          'isFullyPaidByWallet': true,
        },
      );
    }

    // Partial or zero wallet coverage: Create pending order and initiate PhonePe
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
      walletDeductionInput: calc.actualWalletDeductionPaise / 100.0,
      customerId: tokenPayload.sub,
    );

    if (calc.actualWalletDeductionPaise > 0) {
      await customerRepo.updateStoreWalletBalance(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amountDeltaPaise: -calc.actualWalletDeductionPaise,
      );

      await customerRepo.createWalletTransaction(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amount: calc.actualWalletDeductionPaise,
        type: WalletTransactionType.orderDebit.name,
        reference: completeOrder.orderReference,
      );
    }

    final merchantOrderId = completeOrder.orderReference;
    final redirectUrl =
        '${context.request.uri.scheme}://${context.request.uri.authority}/order/status?reference=$merchantOrderId';

    final paymentSession = await phonePeService.initiatePayment(
      config: phonePeConfig,
      merchantOrderId: merchantOrderId,
      amountInPaisa: calc.remainingPayablePaise,
      redirectUrl: redirectUrl,
      storeId: context.storeId,
    );

    return success(
      data: {
        'order': completeOrder,
        'tokenUrl': paymentSession.tokenUrl,
        'phonePeOrderId': paymentSession.orderId,
        'merchantOrderId': merchantOrderId,
        'isFullyPaidByWallet': false,
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
