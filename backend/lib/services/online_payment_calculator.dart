import 'dart:math';

import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/payment_gateway_fee_calculator.dart';
import 'package:typed_sql/typed_sql.dart';

/// Calculation handler for wallet deduction vs online payment gateway remaining amounts and marketplace split.
class OnlinePaymentCalculator {
  const OnlinePaymentCalculator._();

  static Future<
    ({
      int totalAmountPaise,
      int actualWalletDeductionPaise,
      int remainingPayablePaise,
      int merchantSharePaise,
      int platformSharePaise,
      int gatewayChargesPaise,
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
    String? paymentProvider,
  }) async {
    var totalWalletAvailablePaise = await customerRepo.getStoreWalletBalance(
      customerId: customerId,
      storeId: storeId,
    );

    final customer = await customerRepo.getById(customerId);
    final storeRows = await customerRepo.db.stores
        .where((s) => s.id.equals(toExpr(storeId)))
        .fetch();
    if (customer != null && storeRows.isNotEmpty) {
      final bottleCredits = await customerRepo.db.bottleCredits
          .where(
            (c) =>
                c.merchantId.equals(toExpr(storeRows.first.merchantId)) &
                c.customerPhone.equals(toExpr(customer.mobileNumber)),
          )
          .fetch();
      if (bottleCredits.isNotEmpty) {
        totalWalletAvailablePaise += bottleCredits.first.balance * 100;
      }
    }

    final calculated = await orderService.calculateOrderTotals(
      storeId: storeId,
      productsInput: productsList,
      discountTotalInput: discountTotal,
      isOnline: true,
    );

    final netOrderTotalPaise = max(
      0,
      calculated.subtotal + calculated.taxTotal - calculated.discountTotal,
    );

    var actualWalletDeductionPaise = 0;
    if (useWallet && totalWalletAvailablePaise > 0) {
      final orderWithPlatformFee = netOrderTotalPaise + calculated.platformFee;
      actualWalletDeductionPaise = totalWalletAvailablePaise >= orderWithPlatformFee
          ? orderWithPlatformFee
          : totalWalletAvailablePaise;
    }

    final netPayableBeforeGatewayFee = max(
      0,
      netOrderTotalPaise + calculated.platformFee - actualWalletDeductionPaise,
    );

    final gatewayCalc = PaymentGatewayFeeCalculator.calculate(
      provider: paymentProvider,
      amountInPaisa: netPayableBeforeGatewayFee,
    );
    final gatewayChargesPaise = gatewayCalc.gatewayChargesPaise;

    final totalAmountPaise = calculated.grandTotal + gatewayChargesPaise;
    final remainingPayablePaise = netPayableBeforeGatewayFee + gatewayChargesPaise;

    final merchantRemainingOrderPaise = max(
      0,
      netOrderTotalPaise - actualWalletDeductionPaise,
    );
    final merchantSharePaise = merchantRemainingOrderPaise + gatewayChargesPaise;
    final platformSharePaise = max(
      0,
      remainingPayablePaise - merchantSharePaise,
    );

    return (
      totalAmountPaise: totalAmountPaise,
      actualWalletDeductionPaise: actualWalletDeductionPaise,
      remainingPayablePaise: remainingPayablePaise,
      merchantSharePaise: merchantSharePaise,
      platformSharePaise: platformSharePaise,
      gatewayChargesPaise: gatewayChargesPaise,
    );
  }
}
