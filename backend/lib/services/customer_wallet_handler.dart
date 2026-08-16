import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/services/wallet_verification_service.dart';
import 'package:change_case/change_case.dart';
import 'package:models/models.dart';

/// Service handler for customer wallet balance retrieval and top-up transactions.
class CustomerWalletHandler {
  const CustomerWalletHandler._();

  static Future<({double balance, List<Map<String, dynamic>> transactions})> getWalletDetails({
    required CustomerRepository repo,
    required String customerId,
    required String storeId,
  }) async {
    final txRows = await repo.getWalletTransactions(
      customerId: customerId,
      storeId: storeId,
    );

    final verificationService = WalletVerificationService(
      repo: repo,
      phonePeService: PhonePeService(),
    );
    await verificationService.verifyPendingTopUps(
      txRows: txRows,
      storeId: storeId,
      customerId: customerId,
    );

    final balancePaise = await repo.getStoreWalletBalance(
      customerId: customerId,
      storeId: storeId,
    );
    final updatedTxRows = await repo.getWalletTransactions(
      customerId: customerId,
      storeId: storeId,
    );

    final transactions = updatedTxRows.map((row) {
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

  static Map<String, dynamic> formatTransactionJson(CustomerWalletTransactionRow tx) {
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
