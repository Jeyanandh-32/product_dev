import 'package:backend/models/category/category_dto.dart';
import 'package:models/models.dart';

extension CategoryDtoExtension on CategoryDto {
  Category toCategory() => Category(
    id: id,
    name: name,
    merchantId: merchantId,
    storeId: storeId,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
    description: description,
    imageUrl: imageUrl,
  );
}
