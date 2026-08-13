import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension StoreRowExtension on StoreRow {
  Store toStore() => Store(
    id: id,
    merchantId: merchantId,
    name: name,
    storeType: storeType,
    isActive: isActive,
    isOnlineEnabled: isOnlineEnabled,
    activePaymentProvider: activePaymentProvider != null
        ? PaymentProvider.values.firstWhere(
            (p) => p.name == activePaymentProvider,
            orElse: () => PaymentProvider.phonepe,
          )
        : PaymentProvider.phonepe,
    slug: slug,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
