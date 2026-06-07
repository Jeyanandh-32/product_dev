import 'package:validators/src/validation_patterns.dart';
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

    if (!RegExp(ValidationPatterns.whatsapp).hasMatch(whatsappNumber)) {
      return 'Whatsapp Number must be 10 digits.';
    }

    final emailError = _validateEmail(email);
    if (emailError != null) return emailError;

    final passwordError = _validatePassword(password);
    if (passwordError != null) return passwordError;

    return null;
  }

  static String? login({String? email, String? password}) {
    final emailError = _validateEmail(email);
    if (emailError != null) return emailError;

    final passwordError = _validatePassword(password);
    if (passwordError != null) return passwordError;

    return null;
  }

  static String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required.';
    }

    if (!email.isEmail) {
      return 'Invalid Email format.';
    }

    return null;
  }

  static String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }

    if (!RegExp(ValidationPatterns.password).hasMatch(password)) {
      return 'Must be 6+ characters with a number, lowercase, and uppercase.';
    }

    return null;
  }
}
