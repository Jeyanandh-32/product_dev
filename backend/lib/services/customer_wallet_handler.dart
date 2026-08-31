import 'package:backend/database/schema.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/services/wallet_verification_service.dart';
import 'package:change_case/change_case.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart';

/// Service handler for customer wallet balance retrieval and top-up transactions.
class CustomerWalletHandler {
  const CustomerWalletHandler._();

  static Future<({double balance, List<Map<String, dynamic>> transactions})>
  getWalletDetails({
    required CustomerRepository repo,
    required String customerId,
    String? storeId,
  }) async {
    var txRows = <CustomerWalletTransactionRow>[];
    var balancePaise = 0;

    if (storeId != null && storeId.isNotEmpty) {
      final initialTxRowsFuture = repo.getWalletTransactions(
        customerId: customerId,
        storeId: storeId,
      );
      final initialBalanceFuture = repo.getStoreWalletBalance(
        customerId: customerId,
        storeId: storeId,
      );

      final pair = await (initialTxRowsFuture, initialBalanceFuture).wait;
      txRows = pair.$1;
      balancePaise = pair.$2;

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

    var bottleCreditRupees = 0;
    final bottleTxList = <CustomerWalletTransaction>[];

    try {
      final customer = await repo.getById(customerId);
      if (customer != null) {
        if (storeId != null && storeId.isNotEmpty) {
          final storeRows = await repo.db.stores
              .where((s) => s.id.equals(toExpr(storeId)))
              .fetch();
          if (storeRows.isNotEmpty) {
            final merchantId = storeRows.first.merchantId;
            final bottleCredits = await repo.db.bottleCredits
                .where(
                  (c) =>
                      c.merchantId.equals(toExpr(merchantId)) &
                      c.customerPhone.equals(toExpr(customer.mobileNumber)),
                )
                .fetch();
            if (bottleCredits.isNotEmpty) {
              bottleCreditRupees = bottleCredits.first.balance;
            }

            final bottleCreditTxRows = await repo.db.bottleCreditTransactions
                .where(
                  (t) =>
                      t.merchantId.equals(toExpr(merchantId)) &
                      t.customerPhone.equals(toExpr(customer.mobileNumber)),
                )
                .fetch();

            for (final btx in bottleCreditTxRows) {
              bottleTxList.add(
                CustomerWalletTransaction(
                  id: btx.id,
                  customerId: customerId,
                  amount: btx.amount.toDouble(),
                  type: btx.type == BottleCreditTransactionType.credit.name
                      ? WalletTransactionType.refundCredit
                      : WalletTransactionType.orderDebit,
                  reference: 'Bottle Return (${btx.type.toUpperCase()})',
                  status: PaymentStatus.completed.name,
                  createdAt: btx.createdAt,
                ),
              );
            }
          }
        } else {
          final bottleCredits = await repo.db.bottleCredits
              .where(
                (c) => c.customerPhone.equals(toExpr(customer.mobileNumber)),
              )
              .fetch();
          for (final bc in bottleCredits) {
            bottleCreditRupees += bc.balance;
          }

          final bottleCreditTxRows = await repo.db.bottleCreditTransactions
              .where(
                (t) => t.customerPhone.equals(toExpr(customer.mobileNumber)),
              )
              .fetch();

          for (final btx in bottleCreditTxRows) {
            bottleTxList.add(
              CustomerWalletTransaction(
                id: btx.id,
                customerId: customerId,
                amount: btx.amount.toDouble(),
                type: btx.type == BottleCreditTransactionType.credit.name
                    ? WalletTransactionType.refundCredit
                    : WalletTransactionType.orderDebit,
                reference: 'Bottle Return (${btx.type.toUpperCase()})',
                status: PaymentStatus.completed.name,
                createdAt: btx.createdAt,
              ),
            );
          }
        }
      }
    } catch (_) {}

    final allTransactions = [...transactions, ...bottleTxList];
    if (bottleTxList.isNotEmpty) {
      allTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return (
      balance: (balancePaise / 100.0) + bottleCreditRupees,
      transactions: allTransactions.map((t) => t.toJson()).toList(),
    );
  }

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
