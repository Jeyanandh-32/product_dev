class ApiEndpoints {
  const ApiEndpoints._();

  static const String version = 'v1';

  // Auth
  static const String merchantLogin = '/$version/auth/merchant/login';
  static const String merchantRegister = '/$version/auth/merchant/register';
  static const String terminalLogin = '/$version/auth/terminal/login';
  static const String logout = '/$version/auth/logout';

  // Resources
  static const String merchants = '/$version/merchants';
  static const String stores = '/$version/stores';
  static const String terminals = '/$version/terminals';
  static const String counters = '/$version/counters';
  static const String categories = '/$version/categories';
  static const String products = '/$version/products';
  static const String stocks = '/$version/stocks';
  static const String orders = '/$version/orders';
}
