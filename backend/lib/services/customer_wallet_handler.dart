import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/bottle_return_store_cache.dart';
import 'package:backend/services/bottle_reward_wallet_service.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/services/wallet_verification_service.dart';
import 'package:change_case/change_case.dart';
import 'package:models/models.dart';

/// Service handler for customer wallet balance retrieval and top-up transactions.
class CustomerWalletHandler {
  const CustomerWalletHandler._();

  /// Retrieves wallet or bottle return reward details via strict exclusive branching.
  static Future<({double balance, List<Map<String, dynamic>> transactions})>
  getWalletDetails({
    required CustomerRepository repo,
    required String customerId,
    String? storeId,
  }) async {
    if (storeId == null || storeId.isEmpty) {
      return (balance: 0.0, transactions: <Map<String, dynamic>>[]);
    }

    var isBottleStore = false;
    try {
      isBottleStore = await BottleReturnStoreCache.instance
          .isBottleReturnEnabled(storeId, db: repo.db);
    } catch (_) {
      isBottleStore = false;
    }

    if (isBottleStore) {
      return BottleRewardWalletService.getRewardDetails(
        repo: repo,
        customerId: customerId,
        storeId: storeId,
      );
    }

    final initialTxRowsFuture = repo.getWalletTransactions(
      customerId: customerId,
      storeId: storeId,
    );
    final initialBalanceFuture = repo.getStoreWalletBalance(
      customerId: customerId,
      storeId: storeId,
    );

    final pair = await (initialTxRowsFuture, initialBalanceFuture).wait;
    var txRows = pair.$1;
    var balancePaise = pair.$2;

    final hasPending = txRows.any(
      (t) => t.status == PaymentStatus.pending.name,
    );
    if (hasPending) {
      final verificationService = WalletVerificationService(
        repo: repo,
        phonePeService: PhonePeService(),
      );
      await verificationService.verifyPendingTopUps(
        txRows: txRows,
        storeId: storeId,
        customerId: customerId,
      );

      final updatedTxFuture = repo.getWalletTransactions(
        customerId: customerId,
        storeId: storeId,
      );
      final updatedBalanceFuture = repo.getStoreWalletBalance(
        customerId: customerId,
        storeId: storeId,
      );
      final updated = await (updatedTxFuture, updatedBalanceFuture).wait;
      txRows = updated.$1;
      balancePaise = updated.$2;
    }

    final transactions = txRows.map((row) {
      final typeStr = row.type.toCamelCase();
      final txType = WalletTransactionType.values.firstWhere(
        (t) => t.name.toLowerCase() == typeStr.toLowerCase(),
        orElse: () => WalletTransactionType.topUp,
      );

      return CustomerWalletTransaction(
        id: row.id,
        customerId: row.customerId,
        amount: row.amount / 100.0,
        type: txType,
        reference: row.reference,
        status: row.status,
        createdAt: row.createdAt,
      );
    }).toList();

    return (
      balance: balancePaise / 100.0,
      transactions: transactions.map((t) => t.toJson()).toList(),
    );
  }

  /// Formats a raw database transaction row into a response payload.
  static Map<String, dynamic> formatTransactionJson(
    CustomerWalletTransactionRow tx,
  ) {
    return CustomerWalletTransaction(
      id: tx.id,
      customerId: tx.customerId,
      amount: tx.amount / 100.0,
      type: WalletTransactionType.topUp,
      reference: tx.reference,
      status: tx.status,
      createdAt: tx.createdAt,
    ).toJson();
  }
}
