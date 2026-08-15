import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;

/// Helper service for verifying pending customer wallet top-ups with PhonePe status API.
class WalletVerificationService {
  const WalletVerificationService({
    required this.repo,
    required this.phonePeService,
  });

  final CustomerRepository repo;
  final PhonePeService phonePeService;

  Future<void> verifyPendingTopUps({
    required List<CustomerWalletTransactionRow> txRows,
    required String storeId,
    required String customerId,
  }) async {
    final db = Database.db;

    for (final tx in txRows) {
      if (tx.status == 'pending' &&
          tx.reference != null &&
          tx.reference!.startsWith('TOPUP_')) {
        final activeConfigRow = await db.storePhonepeConfigs
            .where(
              (c) =>
                  c.storeId.equals(toExpr(storeId)) &
                  c.isEnabled.equals(toExpr(true)),
            )
            .first
            .fetch();

        if (activeConfigRow != null) {
          try {
            final statusResult = await phonePeService.checkOrderStatus(
              config: activeConfigRow.toStorePhonePeConfig(),
              merchantOrderId: tx.reference!,
            );

            final state = (statusResult['state'] as String?) ??
                (statusResult['data'] is Map
                    ? (statusResult['data'] as Map)['state'] as String?
                    : null);

            if (state == 'COMPLETED') {
              await repo.updateWalletTransactionStatus(
                id: tx.id,
                status: 'completed',
              );
              await repo.updateStoreWalletBalance(
                customerId: customerId,
                storeId: storeId,
                amountDeltaPaise: tx.amount,
              );
            } else if (state == 'FAILED') {
              await repo.updateWalletTransactionStatus(
                id: tx.id,
                status: 'failed',
              );
            }
          } catch (_) {}
        }
      }
    }
  }
}
