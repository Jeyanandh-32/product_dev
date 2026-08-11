import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension CustomerRowExtension on CustomerRow {
  Customer toCustomer() {
    return Customer(
      id: id,
      name: name,
      mobileNumber: mobileNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
