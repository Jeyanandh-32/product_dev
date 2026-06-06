import 'package:validators/validators.dart';

class MerchantValidator {
  const MerchantValidator._();

  static String? register({
    String? name,
    String? businessName,
    String? whatsappNumber,
    String? email,
    String? password,
  }) {
    if (name == null || name.isEmpty) return 'Name is required.';

    if (businessName == null || businessName.isEmpty) {
      return 'Business Name is required.';
    }

    if (whatsappNumber == null || whatsappNumber.isEmpty) {
      return 'Whatsapp Number is required.';
    }

    if (!whatsappNumber.isLength(10, 10)) {
      return 'Whatsapp Number must be 10 digits.';
    }

    if (email == null || email.isEmpty) {
      return 'Email is required.';
    }

    if (!email.isEmail) {
      return 'Ivalid Email format.';
    }

    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }

    if (!password.isLength(6)) {
      return 'Password should be atleast 6 characters.';
    }

    return null;
  }

  static String? login({String? email, String? password}) {
    if (email == null || email.isEmpty) {
      return 'Email is required.';
    }

    if (!email.isEmail) {
      return 'Ivalid Email format.';
    }

    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }

    if (!password.isLength(6)) {
      return 'Password should be atleast 6 characters.';
    }

    return null;
  }
}
