import 'package:backend/models/merchant_dto.dart';
import 'package:models/models.dart';

extension MerchantDtoExtension on MerchantDto {
  Merchant toMerchant() => Merchant(
    id: id,
    name: name,
    businessName: businessName,
    whatsappNumber: whatsappNumber,
    email: email,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
