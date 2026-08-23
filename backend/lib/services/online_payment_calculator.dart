import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:typed_sql/typed_sql.dart';

/// Calculation handler for wallet deduction vs online payment gateway remaining amounts.
class OnlinePaymentCalculator {
  const OnlinePaymentCalculator._();

  static Future<({int totalAmountPaise, int actualWalletDeductionPaise, int remainingPayablePaise})> computeAmounts({
    required OrderService orderService,
    required CustomerRepository customerRepo,
    required String customerId,
    required String storeId,
    required List<Map<String, dynamic>> productsList,
    required double discountTotal,
    required bool useWallet,
  }) async {
    var totalWalletAvailablePaise = await customerRepo.getStoreWalletBalance(
      customerId: customerId,
      storeId: storeId,
    );

    final customer = await customerRepo.getById(customerId);
    final storeRows = await customerRepo.db.stores.where((s) => s.id.equals(toExpr(storeId))).fetch();
    if (customer != null && storeRows.isNotEmpty) {
      final bottleCredits = await customerRepo.db.bottleCredits
          .where((c) => c.merchantId.equals(toExpr(storeRows.first.merchantId)) & c.customerPhone.equals(toExpr(customer.mobileNumber)))
          .fetch();
      if (bottleCredits.isNotEmpty) {
        totalWalletAvailablePaise += bottleCredits.first.balance * 100;
      }
    }

    final calculated = await orderService.calculateOrderTotals(
      storeId: storeId,
      productsInput: productsList,
      discountTotalInput: discountTotal,
    );

    final totalAmountPaise = calculated.grandTotal;
    var actualWalletDeductionPaise = 0;
    var remainingPayablePaise = totalAmountPaise;

    if (useWallet && totalWalletAvailablePaise > 0) {
      actualWalletDeductionPaise = totalWalletAvailablePaise >= totalAmountPaise ? totalAmountPaise : totalWalletAvailablePaise;
      remainingPayablePaise = totalAmountPaise - actualWalletDeductionPaise;
    }

    return (
      totalAmountPaise: totalAmountPaise,
      actualWalletDeductionPaise: actualWalletDeductionPaise,
      remainingPayablePaise: remainingPayablePaise,
    );
  }
}
