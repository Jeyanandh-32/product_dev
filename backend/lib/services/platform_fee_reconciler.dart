import 'package:backend/repositories/platform_fee_repository.dart';
import 'package:backend/repositories/platform_phonepe_config_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:models/models.dart';

/// Service coordinating status checks and reconciliation for pending platform fee settlements.
class PlatformFeeReconciler {
  PlatformFeeReconciler({
    required this.platformFeeRepo,
    required this.configRepo,
    PhonePeService? phonePeService,
  }) : phonePeService = phonePeService ?? PhonePeService();

  final PlatformFeeRepository platformFeeRepo;
  final PlatformPhonePeConfigRepository configRepo;
  final PhonePeService phonePeService;

  /// Reconciles all pending settlements for a merchant against PhonePe Order Status API.
  Future<void> reconcileMerchantPendingSettlements(String merchantId) async {
    final pending = await platformFeeRepo.getPendingSettlements(merchantId);
    if (pending.isEmpty) return;

    final config = configRepo.getConfig();
    if (config == null || !config.isEnabled) return;

    for (final settlement in pending) {
      await _reconcileSettlement(settlement, config);
    }
  }

  Future<void> _reconcileSettlement(
    PlatformFeeSettlement settlement,
    PlatformPhonePeConfig config,
  ) async {
    try {
      final storeConfig = config.toStorePhonePeConfig(storeId: settlement.id);
      final statusRes = await phonePeService.checkOrderStatus(
        config: storeConfig,
        merchantOrderId: 'PFS_${settlement.id}',
      );

      final state =
          (statusRes['state'] as String?) ??
          (statusRes['data'] is Map
              ? (statusRes['data'] as Map)['state'] as String?
              : null);
      final stateUpper = state?.toUpperCase();

      if (stateUpper == 'COMPLETED' || stateUpper == 'SUCCESS') {
        final txId = _extractTransactionId(statusRes, settlement.id);
        await platformFeeRepo.markSettlementCompleted(
          settlementId: settlement.id,
          paymentTransactionId: txId,
        );
      } else if (stateUpper == 'FAILED' || stateUpper == 'CANCELLED') {
        await platformFeeRepo.markSettlementFailed(settlement.id);
      }
    } catch (_) {
      // Avoid breaking summary if PhonePe status API call fails
    }
  }

  String _extractTransactionId(Map<String, dynamic> res, String fallbackId) {
    if (res['transactionId'] != null) return '${res['transactionId']}';
    if (res['paymentDetails'] is List) {
      final list = res['paymentDetails'] as List;
      if (list.isNotEmpty && list.first is Map) {
        final first = list.first as Map;
        if (first['transactionId'] != null) return '${first['transactionId']}';
      }
    }
    return 'PFS_$fallbackId';
  }
}
