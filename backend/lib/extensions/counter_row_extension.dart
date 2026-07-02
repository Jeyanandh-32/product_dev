import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension CounterRowExtension on CounterRow {
  Counter toCounter() => Counter(
        id: id,
        name: name,
        merchantId: merchantId,
        storeId: storeId,
        isActive: isActive,
        description: description,
        imageUrl: imageUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
