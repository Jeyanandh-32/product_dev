import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension MerchantRowExtension on MerchantRow {
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
