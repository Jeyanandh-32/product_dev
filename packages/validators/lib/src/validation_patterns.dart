/// Regular expression patterns used for common field validation.
class ValidationPatterns {
  const ValidationPatterns._();

  /// Strong password pattern requiring uppercase, lowercase, digit, and min 6 characters.
  static const String password = r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$';

  /// Standard 10-digit Indian mobile/WhatsApp number pattern.
  static const String whatsapp = r'^[0-9]{10}$';

  /// HTML input pattern attribute format for 10-digit WhatsApp numbers.
  static const String whatsappHtml = r'[0-9]{10}';
}
