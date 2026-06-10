import 'package:backend/models/counter/counter_dto.dart';
import 'package:models/models.dart';

extension CounterDtoExtension on CounterDto {
  Counter toCounter() => Counter(
    id: id,
    name: name,
    merchantId: merchantId,
    storeId: storeId,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
