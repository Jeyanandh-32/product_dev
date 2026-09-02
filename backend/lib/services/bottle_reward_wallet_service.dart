import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart';

/// Dedicated service retrieving bottle return reward credits and transaction history.
class BottleRewardWalletService {
  const BottleRewardWalletService._();

  /// Fetches bottle reward balance and history for a customer at a given store in 2 parallel hops.
  static Future<({double balance, List<Map<String, dynamic>> transactions})>
  getRewardDetails({
    required CustomerRepository repo,
    required String customerId,
    required String storeId,
  }) async {
    final customerFuture = repo.getById(customerId);
    final storeFuture = repo.db.stores
        .where((s) => s.id.equals(toExpr(storeId)))
        .fetch();

    final (customer, storeRows) = await (customerFuture, storeFuture).wait;
    if (customer == null || storeRows.isEmpty) {
      return (balance: 0.0, transactions: <Map<String, dynamic>>[]);
    }

    final merchantId = storeRows.first.merchantId;
    final customerPhone = customer.mobileNumber;

    final creditsFuture = repo.db.bottleCredits
        .where(
          (c) =>
              c.merchantId.equals(toExpr(merchantId)) &
              c.customerPhone.equals(toExpr(customerPhone)),
        )
        .fetch();

    final txFuture = repo.db.bottleCreditTransactions
        .where(
          (t) =>
              t.merchantId.equals(toExpr(merchantId)) &
              t.customerPhone.equals(toExpr(customerPhone)),
        )
        .fetch();

    final (credits, txRows) = await (creditsFuture, txFuture).wait;

    final balance = credits.isNotEmpty ? credits.first.balance.toDouble() : 0.0;

    final transactions = txRows.map((btx) {
      return CustomerWalletTransaction(
        id: btx.id,
        customerId: customerId,
        amount: btx.amount.toDouble(),
        type: btx.type == BottleCreditTransactionType.credit.name
            ? WalletTransactionType.refundCredit
            : WalletTransactionType.orderDebit,
        reference: 'Bottle Return (${btx.type.toUpperCase()})',
        status: PaymentStatus.completed.name,
        createdAt: btx.createdAt,
      );
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return (
      balance: balance,
      transactions: transactions.map((t) => t.toJson()).toList(),
    );
  }
}
