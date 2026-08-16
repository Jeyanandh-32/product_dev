import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

/// Coordinator for completing wallet-only and PhonePe hybrid online orders.
class OnlineOrderCheckoutCoordinator {
  const OnlineOrderCheckoutCoordinator._();

  static Future<Response> handleWalletOnlyOrder({
    required OrderService orderService,
    required CustomerRepository customerRepo,
    required String merchantId,
    required String storeId,
    required String customerId,
    required List<Map<String, dynamic>> productsList,
    required double discountTotal,
    required int walletDeductionPaise,
  }) async {
    final completedOrder = await orderService.checkout(
      merchantId: merchantId,
      storeId: storeId,
      productsInput: productsList,
      source: OrderSource.web,
      type: OrderType.takeaway,
      paymentMethod: PaymentMethod.upi,
      status: OrderStatus.pending,
      discountTotalInput: discountTotal,
      walletDeductionInput: walletDeductionPaise / 100.0,
      customerId: customerId,
    );

    await customerRepo.updateStoreWalletBalance(
      customerId: customerId,
      storeId: storeId,
      amountDeltaPaise: -walletDeductionPaise,
    );

    await customerRepo.createWalletTransaction(
      customerId: customerId,
      storeId: storeId,
      amount: walletDeductionPaise,
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

  static Future<Response> handlePhonePeHybridOrder({
    required OrderService orderService,
    required CustomerRepository customerRepo,
    required PhonePeService phonePeService,
    required StorePhonePeConfig phonePeConfig,
    required RequestContext context,
    required String merchantId,
    required String storeId,
    required String customerId,
    required List<Map<String, dynamic>> productsList,
    required double discountTotal,
    required int walletDeductionPaise,
    required int remainingPayablePaise,
  }) async {
    final completeOrder = await orderService.checkout(
      merchantId: merchantId,
      storeId: storeId,
      productsInput: productsList,
      source: OrderSource.web,
      type: OrderType.takeaway,
      paymentMethod: PaymentMethod.upi,
      status: OrderStatus.pending,
      paymentStatus: PaymentStatus.pending,
      discountTotalInput: discountTotal,
      walletDeductionInput: walletDeductionPaise / 100.0,
      customerId: customerId,
    );

    if (walletDeductionPaise > 0) {
      await customerRepo.updateStoreWalletBalance(
        customerId: customerId,
        storeId: storeId,
        amountDeltaPaise: -walletDeductionPaise,
      );

      await customerRepo.createWalletTransaction(
        customerId: customerId,
        storeId: storeId,
        amount: walletDeductionPaise,
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
      amountInPaisa: remainingPayablePaise,
      redirectUrl: redirectUrl,
      storeId: storeId,
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
  }
}
