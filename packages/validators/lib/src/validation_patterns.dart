class ValidationPatterns {
  const ValidationPatterns._();

  static const String password = r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$';
  static const String whatsapp = r'^[0-9]{10}$';
  static const String whatsappHtml = r'[0-9]{10}';
}
