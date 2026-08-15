import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/order_service.dart';

/// Calculation handler for wallet deduction vs online payment gateway remaining amounts.
class OnlinePaymentCalculator {
  const OnlinePaymentCalculator._();

  static Future<
    ({
      int totalAmountPaise,
      int actualWalletDeductionPaise,
      int remainingPayablePaise,
    })
  >
  computeAmounts({
    required OrderService orderService,
    required CustomerRepository customerRepo,
    required String customerId,
    required String storeId,
    required List<Map<String, dynamic>> productsList,
    required double discountTotal,
    required bool useWallet,
  }) async {
    final walletBalancePaise = await customerRepo.getStoreWalletBalance(
      customerId: customerId,
      storeId: storeId,
    );

    final calculated = await orderService.calculateOrderTotals(
      storeId: storeId,
      productsInput: productsList,
      discountTotalInput: discountTotal,
    );

    final totalAmountPaise = calculated.grandTotal;
    var actualWalletDeductionPaise = 0;
    var remainingPayablePaise = totalAmountPaise;

    if (useWallet && walletBalancePaise > 0) {
      actualWalletDeductionPaise =
          walletBalancePaise >= totalAmountPaise
              ? totalAmountPaise
              : walletBalancePaise;
      remainingPayablePaise = totalAmountPaise - actualWalletDeductionPaise;
    }

    return (
      totalAmountPaise: totalAmountPaise,
      actualWalletDeductionPaise: actualWalletDeductionPaise,
      remainingPayablePaise: remainingPayablePaise,
    );
  }
}
