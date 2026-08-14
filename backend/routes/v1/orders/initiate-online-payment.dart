import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
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

    // 2. Calculate store wallet deduction & remaining payable amount
    final customerRepo = context.read<CustomerRepository>();
    final walletBalancePaise = await customerRepo.getStoreWalletBalance(
      customerId: tokenPayload.sub,
      storeId: context.storeId,
    );
    final useWallet = input.useWallet ?? false;

    // Calculate totals without creating a preliminary order
    final calculated = await orderService.calculateOrderTotals(
      storeId: context.storeId,
      productsInput: productsList,
      discountTotalInput: input.discountTotal ?? 0.0,
    );

    final totalAmountPaise = calculated.grandTotal;
    var actualWalletDeductionPaise = 0;
    var remainingPayablePaise = totalAmountPaise;

    if (useWallet && walletBalancePaise > 0) {
      actualWalletDeductionPaise = walletBalancePaise >= totalAmountPaise ? totalAmountPaise : walletBalancePaise;
      remainingPayablePaise = totalAmountPaise - actualWalletDeductionPaise;
    }

    // 3. If 100% covered by Wallet -> Create single completed order immediately
    if (remainingPayablePaise <= 0) {
      final completedOrder = await orderService.checkout(
        merchantId: storeRow.merchantId,
        storeId: context.storeId,
        productsInput: productsList,
        source: OrderSource.web,
        type: OrderType.takeaway,
        paymentMethod: PaymentMethod.upi,
        status: OrderStatus.pending,
        discountTotalInput: input.discountTotal ?? 0.0,
        walletDeductionInput: actualWalletDeductionPaise / 100.0,
        customerId: tokenPayload.sub,
      );

      // Debit customer store wallet balance
      await customerRepo.updateStoreWalletBalance(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amountDeltaPaise: -actualWalletDeductionPaise,
      );

      await customerRepo.createWalletTransaction(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amount: actualWalletDeductionPaise,
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

    // 4. Partial coverage: Create single order with wallet deduction and initiate PhonePe for remaining balance
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
      walletDeductionInput: actualWalletDeductionPaise / 100.0,
      customerId: tokenPayload.sub,
    );

    // Debit customer store wallet balance for partial usage
    if (actualWalletDeductionPaise > 0) {
      await customerRepo.updateStoreWalletBalance(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amountDeltaPaise: -actualWalletDeductionPaise,
      );

      await customerRepo.createWalletTransaction(
        customerId: tokenPayload.sub,
        storeId: context.storeId,
        amount: actualWalletDeductionPaise,
        type: WalletTransactionType.orderDebit.name,
        reference: completeOrder.orderReference,
      );
    }

    final merchantOrderId = completeOrder.orderReference;
    final redirectUrl = '${context.request.uri.scheme}://${context.request.uri.authority}/order/status?reference=$merchantOrderId';

    // Initiate PhonePe checkout session for remaining balance
    final paymentSession = await phonePeService.initiatePayment(
      config: phonePeConfig,
      merchantOrderId: merchantOrderId,
      amountInPaisa: remainingPayablePaise,
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
