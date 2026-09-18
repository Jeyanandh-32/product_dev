import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

/// Extension methods for converting [PlatformFeeSettlementRow] to domain models.
extension PlatformFeeSettlementRowExtension on PlatformFeeSettlementRow {
  /// Maps a database [PlatformFeeSettlementRow] into a domain [PlatformFeeSettlement].
  PlatformFeeSettlement toModel() => PlatformFeeSettlement(
        id: id,
        merchantId: merchantId,
        amountInPaise: amountInPaise,
        ordersCount: ordersCount,
        paymentGateway: paymentGateway,
        paymentTransactionId: paymentTransactionId,
        status: status,
        createdAt: createdAt,
        settledAt: settledAt,
      );
}
