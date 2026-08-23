import 'package:backend/repositories/bottle_credit_handler.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:models/models.dart';

/// Handles wallet balance deduction and bottle return credit deductions during checkout.
class OnlineWalletDeductionHandler {
  const OnlineWalletDeductionHandler._();

  /// Applies deduction across store wallet and bottle return credits.
  static Future<void> applyDeduction({
    required CustomerRepository customerRepo,
    required String merchantId,
    required String storeId,
    required String customerId,
    required int walletDeductionPaise,
    required String orderReference,
    String? orderId,
  }) async {
    if (walletDeductionPaise <= 0) return;

    final storeWalletBalancePaise = await customerRepo.getStoreWalletBalance(
      customerId: customerId,
      storeId: storeId,
    );

    final fromStoreWallet = storeWalletBalancePaise >= walletDeductionPaise
        ? walletDeductionPaise
        : storeWalletBalancePaise;
    final fromBottleCreditPaise = walletDeductionPaise - fromStoreWallet;

    if (fromStoreWallet > 0) {
      await customerRepo.updateStoreWalletBalance(
        customerId: customerId,
        storeId: storeId,
        amountDeltaPaise: -fromStoreWallet,
      );

      await customerRepo.createWalletTransaction(
        customerId: customerId,
        storeId: storeId,
        amount: fromStoreWallet,
        type: WalletTransactionType.orderDebit.name,
        reference: orderReference,
      );
    }

    if (fromBottleCreditPaise > 0) {
      final customer = await customerRepo.getById(customerId);
      if (customer != null) {
        final bottleCreditHandler = BottleCreditHandler(customerRepo.db);
        final bottleCreditRupees = (fromBottleCreditPaise / 100.0).ceil();
        await bottleCreditHandler.applyCreditDeduction(
          merchantId: merchantId,
          customerPhone: customer.mobileNumber,
          amount: bottleCreditRupees,
          storeId: storeId,
          orderId: orderId,
        );
      }
    }
  }
}
