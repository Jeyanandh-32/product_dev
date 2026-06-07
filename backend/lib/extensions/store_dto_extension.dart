import 'package:backend/models/store/store_dto.dart';
import 'package:models/models.dart';

extension StoreDtoExtension on StoreDto {
  Store toStore() => Store(
    id: id,
    merchantId: merchantId,
    name: name,
    storeType: storeType,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
