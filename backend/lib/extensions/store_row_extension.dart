import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension StoreRowExtension on StoreRow {
  Store toStore() => Store(
    id: id,
    merchantId: merchantId,
    name: name,
    storeType: storeType,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
